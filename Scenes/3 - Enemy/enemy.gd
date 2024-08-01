extends RigidBody3D


@onready var nav_agent = $NavigationAgent3D
@onready var player = $"../Player"


const SPEED = 2250.0
const DESIRED_LIGHT_STATE := true


func _physics_process(delta):
	var current_location = global_transform.origin
	#print("Loc", current_location)
	var next_location = nav_agent.get_next_path_position()
	#print("Next", next_location)
	var direction = (next_location - current_location)
	direction.y = 0
	var new_velocity = direction.normalized() * SPEED * delta
	
	apply_central_force(new_velocity)

func update_target_location(target_location):
	nav_agent.target_position = target_location


func get_desired_light_state() -> bool:
	return DESIRED_LIGHT_STATE
