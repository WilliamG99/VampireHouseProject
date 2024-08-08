extends RigidBody3D


@onready var player = $"../Player"

@onready var mesh = $frankenstein
@onready var hand = $frankenstein/EnemyHand
@onready var nav_agent = $NavigationAgent3D
@onready var throw_timer = $ThrowTimer
@onready var pick_up_timer = $PickUpTimer
@onready var anim_tree = $frankenstein/AnimationTree

# Get sound refference
@onready var ary_wood_walking_sounds = [
	$Step1,
	$Step2,
	$Step3,
	$Step4,
	$Step5,
	$Step6,
	]
# Walk cycle timer
@onready var walk_cycle = $Audio/WalkCycle

	
const SPEED = 1500.0
const LERP_VAL := 0.1
const DESIRED_LIGHT_STATE := true
const AIM_DIR_Y := Vector3(0,0,0)
const THROW_SPEED := 3000

var near_prop := false
var holding_prop := false
var prop_node : RigidBody3D
var aim_dir : Vector3
var player_location : Vector3
var prop_interact = Prop_Interact.new()

var throw_timer_on := false
var pick_up_timer_on := false

var current_location := global_position
var next_location : Vector3
var direction : Vector3


func get_desired_light_state() -> bool:
	return DESIRED_LIGHT_STATE


func update_target_location(target_location) -> void:
	player_location = target_location
	nav_agent.target_position = target_location


func _physics_process(delta) -> void:
	update_target_location(player.global_position)
	current_location = global_transform.origin
	next_location = nav_agent.get_next_path_position()
	direction = (next_location - current_location).normalized()
	direction.y = 0

	rotation.y = lerp_angle(rotation.y, (atan2(-direction.x, -direction.z)), LERP_VAL)
	#mesh.rotation.y = lerp_angle(mesh.rotation.y, (atan2(-direction.x * 1200.0, -direction.z * 1200.0)), LERP_VAL)
	
	apply_central_force(direction * SPEED * delta)
	if SPEED > 0.0:
		anim_tree.set("parameters/isRunning/transition_request", "true")
		if walk_cycle.time_left <= 0:
			var i = randi_range(0, 5)
			ary_wood_walking_sounds[i].pitch_scale = 0.8
			ary_wood_walking_sounds[i].play()
			walk_cycle.start(0.3)
			
	elif SPEED == 0.0:
		anim_tree.set("parameters/isRunning/transition_request", "false")
	
	# Prop Interaction
	# enemy has two timers, one for next prop pickup time and other for time till throw after pickup
	if near_prop and !holding_prop and !pick_up_timer_on:
		anim_tree.set("parameters/isHolding/transition_request", "true")
		holding_prop = true
		throw_timer_on = true
		throw_timer.start()
	
	if holding_prop:
		prop_interact.is_near = near_prop
		prop_interact.is_holding = holding_prop
		prop_interact.prop_rotation_degrees_y = mesh.global_rotation_degrees.y
		prop_interact.prop_position = hand.global_position
		prop_interact.target_location = player_location
		
		prop_node.pick_up(prop_interact)
		
		if !throw_timer_on:
			holding_prop = false
			pick_up_timer_on = true
			pick_up_timer.start()
			
			anim_tree.set("parameters/isHolding/transition_request", "false")
			
			aim_dir = -mesh.global_transform.basis.z
			prop_interact.prop_aim_direction = aim_dir
			prop_interact.prop_aim_direction_y = AIM_DIR_Y
			prop_interact.prop_throw_speed = THROW_SPEED * delta
			
			prop_node.throw(prop_interact)


func frank_hit():
	anim_tree.set("parameters/isHit/transition_request", "true")


# Prop Interaction Collison Signals
func _on_prop_interact_area_body_entered(body) -> void:
	if body.has_method("pick_up"):
		near_prop = true
		prop_node = body

func _on_prop_interact_area_body_exited(body) -> void:
	if body.has_method("pick_up"):
		near_prop = false
		prop_node = null


func _on_throw_timer_timeout():
	throw_timer_on = false

func _on_pick_up_timer_timeout():
	pick_up_timer_on = false
