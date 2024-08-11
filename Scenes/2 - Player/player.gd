extends RigidBody3D


@onready var mesh = $VampireKid
@onready var hand = $VampireKid/PlayerHand
@onready var spring_arm_pivot = $SpringArmPivot
@onready var spring_arm = $SpringArmPivot/SpringArm3D
@onready var raycast = $SpringArmPivot/SpringArm3D/Camera3D/RayCast3D
@onready var anim_tree = $VampireKid/AnimationTree
@onready var game_won_area = $".."/GameWon
@onready var popup = %PopupInstructions
@onready var popup_timer = %InstructionTimer
@onready var popup_rect = %ColorRect


# Get audio references
@onready var throw = $Audio/Throw
@onready var ary_wood_walking_sounds = [
	$Audio/WoodSteps/Step1,
	$Audio/WoodSteps/Step2,
	$Audio/WoodSteps/Step3,
	$Audio/WoodSteps/Step4,
	$Audio/WoodSteps/Step5,
	$Audio/WoodSteps/Step6,
	]
@onready var pickup = $Audio/Equip
# Walk sound timer
@onready var walk_cycle = $WalkCycle

var SPEED := 2250.0
const LERP_VAL := 0.3
const DESIRED_LIGHT_STATE := false
const AIM_DIR_Y := Vector3(0,0,0)
const THROW_SPEED := 3000

var direction : Vector3

var near_prop := false
var holding_prop := false
var prop_nodes = []
var prop_node
var aim_dir : Vector3

var lock_on_node
var locking_on := false

var in_snack_area := false

var prop_interact = Prop_Interact.new()


func _set_in_snack_area(player_snack_area : bool):
	in_snack_area = player_snack_area

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# Camera Movements with Mouse
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		spring_arm_pivot.rotate_y(-event.relative.x * 0.002)
		spring_arm.rotate_x(-event.relative.y * 0.002)
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/4, PI/4)
		
	# Game Mouse Mode
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# Prop Interaction
	if near_prop and !holding_prop and Input.is_action_just_pressed("interact"):
		pickup.play()
		holding_prop = true
		anim_tree.set("parameters/isHoldingRunning/transition_request", "true")
		anim_tree.set("parameters/isHoldingIdle/transition_request", "true")
		prop_node = prop_nodes.front()
	
	# Trigger snack event and wakes frank
	if in_snack_area and Input.is_action_just_pressed("interact"):
		$"../Enemy".set_frank_awake()
		get_tree().call_group("Lights", "turn_on_lights")
		$"..".add_child(game_won_area)
		
		# Trigger pop instructions
		popup.text = " RUN!!! "
		popup.visible = true
		popup_rect.visible = true
		popup_timer.start(1.5)

func get_desired_light_state() -> bool:
	return DESIRED_LIGHT_STATE


func _physics_process(delta) -> void:
	print(near_prop, " Near Prop")
	print(holding_prop, " Holding Prop")
	print(prop_nodes)
	print(prop_node)
	
	# Player Movement
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward","move_backward")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = direction.rotated(Vector3.UP, spring_arm_pivot.rotation.y)

	
	if direction:
		if walk_cycle.time_left <= 0:
			ary_wood_walking_sounds[randi_range(0, 5)].play()
			walk_cycle.start(0.3)
		apply_central_force(direction * SPEED * delta)
		anim_tree.set("parameters/isRunning/transition_request", "true")
		mesh.rotation.y = lerp_angle(mesh.rotation.y, atan2(-direction.x, -direction.z), LERP_VAL)
	else:
		anim_tree.set("parameters/isRunning/transition_request", "false")
	
	# Prop Interaction
	if holding_prop:
		prop_interact.is_near = near_prop
		prop_interact.is_holding = holding_prop
		prop_interact.prop_rotation_degrees_y = mesh.global_rotation_degrees.y
		prop_interact.prop_position = hand.global_position
		prop_node.get_parent().pick_up(prop_interact)
		
		# Locking On
		if !locking_on and Input.is_action_just_pressed("aim"):
			locking_on = true
			SPEED = 0.0
			print("locking_on ", locking_on)
			
		elif locking_on and Input.is_action_just_released("aim"):
			locking_on = false
			SPEED = 2250.0
			print("locking_on ", locking_on)
		
		if Input.is_action_just_pressed("throw") and !locking_on:
			holding_prop = false
			aim_dir = -mesh.global_transform.basis.z
			prop_interact.prop_aim_direction = aim_dir
			prop_interact.prop_aim_direction_y = AIM_DIR_Y
			prop_interact.prop_throw_speed = THROW_SPEED * delta
			throw.play()
			
			if prop_node.get_parent().has_method("throw"):
				prop_node.get_parent().throw(prop_interact)
			elif prop_node.get_parent().get_parent().has_method("throw"):
				prop_node.get_parent().get_parent().throw(prop_interact)
				
		elif Input.is_action_just_pressed("throw") and locking_on:
			holding_prop = false
			locking_on = false
			SPEED = 2250.0
			if lock_on_node:
				aim_dir = (lock_on_node.global_position - global_position).normalized()
			else:
				aim_dir = -mesh.global_transform.basis.z
			prop_interact.prop_aim_direction = aim_dir
			prop_interact.prop_aim_direction_y = Vector3(0,0,0)
			prop_interact.prop_throw_speed = THROW_SPEED * delta
			prop_node.get_parent().throw(prop_interact)


	if holding_prop and locking_on and raycast.get_collider():
		lock_on_node = raycast.get_collider().get_parent()
		lock_on_node._is_locked_on()
	elif holding_prop and (locking_on and !raycast.get_collider() or !locking_on and raycast.get_collider()):
		if lock_on_node:
			lock_on_node._is_locked_off()
			lock_on_node = null
	elif !holding_prop:
		if lock_on_node:
			lock_on_node._is_locked_off()
			lock_on_node = null
			locking_on = false
			SPEED = 2250.0


# Prop Interaction Collison Signals
func _on_prop_interact_area_body_entered(body) -> void:
	if holding_prop:
		return
	elif body.has_method("pick_up") or body.get_parent().has_method("pick_up") or body.get_parent().get_parent().has_method("pick_up"):
		near_prop = true
		prop_nodes.append(body)
		print(prop_nodes)

func _on_prop_interact_area_body_exited(body) -> void:
	if holding_prop:
		return
	elif body.has_method("pick_up")  or body.get_parent().has_method("pick_up") or body.get_parent().get_parent().has_method("pick_up"):
		anim_tree.set("parameters/isHoldingRunning/transition_request", "false")
		anim_tree.set("parameters/isHoldingIdle/transition_request", "false")
		prop_nodes.erase(body)
		
		if prop_nodes.is_empty():
			near_prop = false
			holding_prop = false
			prop_node = []


func game_over():
	print("GAME OVER")
	get_tree().change_scene_to_file("res://Scenes/7 - Menu/Scenes/game_over.tscn")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

# Enemy Collision
func _on_body_entered(body):
	print("HIT!")
	if body.name == "Enemy":
		game_over()

func in_light():
	print("Inlight")
	SPEED = 625

func out_light():
	print("Out of light")
	SPEED = 2250.0

func in_lightning():
	SPEED = 0.0
	freeze = true

func out_lightning():
	SPEED = 2250.0
	freeze = false


# Bedroom Reached - Game Won
func bedroom_reached():
	print("GAME END")
