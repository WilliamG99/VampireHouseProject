extends RigidBody3D


@onready var mesh = $PlayerMesh
@onready var hand = $PlayerMesh/PlayerHand
@onready var spring_arm_pivot = $SpringArmPivot
@onready var spring_arm = $SpringArmPivot/SpringArm3D
@onready var aim_raycast = $AimRaycast

const SPEED := 2250.0
const LERP_VAL := 0.5
const DESIRED_LIGHT_STATE := false
const AIM_DIR_Y := Vector3(0,15,0)
const THROW_SPEED := 3000

var near_prop := false
var holding_prop := false
var prop_node : RigidBody3D
var aim_dir : Vector3


var prop_interact = Prop_Interact.new()


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
		holding_prop = true

func get_desired_light_state() -> bool:
	return DESIRED_LIGHT_STATE


func _physics_process(delta) -> void:
	# Player Movement
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward","move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = direction.rotated(Vector3.UP, spring_arm_pivot.rotation.y)
	rotation.y = spring_arm_pivot.rotation.y
	mesh.rotation.y = spring_arm_pivot.rotation.y
	
	if direction:
		apply_central_force(direction * SPEED * delta)
		#mesh.rotation.y = lerp_angle(mesh.rotation.y, (atan2(-direction.x * 1200.0, -direction.z * 1200.0)), LERP_VAL)
	
	
	# Prop Interaction
	if holding_prop:
		prop_interact.is_near = near_prop
		prop_interact.is_holding = holding_prop
		prop_interact.prop_rotation_degrees_y = mesh.global_rotation_degrees.y
		prop_interact.prop_position = hand.global_position
		
		prop_node.pick_up(prop_interact)
		
		if Input.is_action_just_pressed("throw"):
			holding_prop = false
			aim_dir = -mesh.global_transform.basis.z
			prop_interact.prop_aim_direction = aim_dir
			prop_interact.prop_aim_direction_y = AIM_DIR_Y
			prop_interact.prop_throw_speed = THROW_SPEED * delta
			prop_node.throw(prop_interact)

# Prop Interaction Collison Signals
func _on_prop_interact_area_body_entered(body) -> void:
	if body.has_method("pick_up"):
		near_prop = true
		prop_node = body

func _on_prop_interact_area_body_exited(body) -> void:
	if body.has_method("pick_up"):
		near_prop = false
		prop_node = null
