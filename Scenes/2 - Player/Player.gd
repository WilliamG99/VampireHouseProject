extends RigidBody3D

@onready var mesh = $MeshInstance3D
@onready var spring_arm_pivot = $SpringArmPivot
@onready var spring_arm = $SpringArmPivot/SpringArm3D
@onready var raycast = $SpringArmPivot/SpringArm3D/Camera3D/RayCast3D

const SPEED := 2250.0
const LERP_VAL := 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	raycast.add_exception($".")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		spring_arm_pivot.rotate_y(-event.relative.x * 0.002)
		spring_arm.rotate_x(-event.relative.y * 0.002)
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/4, PI/4)


func _process(delta) -> void:
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward","move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = direction.rotated(Vector3.UP, spring_arm_pivot.rotation.y)
	
	if direction:
		apply_central_force(direction * SPEED * delta)
		mesh.rotation.y = lerp_angle(mesh.rotation.y, (atan2(-direction.x * 1200.0, -direction.z * 1200.0)), LERP_VAL)
		


