extends RigidBody3D


@onready var mesh = $EnemyMesh
@onready var hand = $EnemyMesh/EnemyHand
@onready var nav_agent = $NavigationAgent3D
@onready var throw_timer = $ThrowTimer
@onready var pick_up_timer = $PickUpTimer


const SPEED = 0.0
const LERP_VAL := 0.05
const DESIRED_LIGHT_STATE := true

var near_prop := false
var holding_prop := false
var prop_node : RigidBody3D
var throw_timer_on := false
var pick_up_timer_on := false

var prop_interact = Prop_Interact.new()


func get_desired_light_state() -> bool:
	return DESIRED_LIGHT_STATE


func update_target_location(target_location) -> void:
	nav_agent.target_position = target_location


#func _physics_process(delta) -> void:
	#var current_location = global_transform.origin
	##print("Loc", current_location)
	#var next_location = nav_agent.get_next_path_position()
	##print("Next", next_location)
	#var direction = (next_location - current_location)
	#direction.y = 0
	#var new_velocity = direction.normalized() * SPEED * delta
	#
	#apply_central_force(new_velocity)
	#mesh.rotation.y = lerp_angle(mesh.rotation.y, (atan2(-direction.x * 1200.0, -direction.z * 1200.0)), LERP_VAL)
	#
	## Prop Interaction
	## enemy has two timers, one for next prop pickup time and other for time till throw after pickup
	#if near_prop and !holding_prop and !pick_up_timer_on:
		#holding_prop = true
		#throw_timer_on = true
		#throw_timer.start()
	#
	#if holding_prop:
		#prop_interact.is_near = near_prop
		#prop_interact.is_holding = holding_prop
		#prop_interact.prop_rotation_degrees_y = mesh.global_rotation_degrees.y
		#prop_interact.prop_position = hand.global_position
		#
		#prop_node.pick_up(prop_interact)
		#
		#if !throw_timer_on:
			#holding_prop = false
			#pick_up_timer_on = true
			#pick_up_timer.start()
			#prop_node.throw(prop_interact)


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
