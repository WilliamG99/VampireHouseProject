extends RigidBody3D

@onready var nav_agent = $NavigationAgent3D
@onready var player = $"../Player"

const SPEED = 13

func _physics_process(delta):
	var current_location = global_transform.origin
	#print("Loc", current_location)
	var next_location = nav_agent.get_next_path_position()
	#print("Next", next_location)
	var new_velocity = (next_location - current_location)
	new_velocity.y = 0
	new_velocity = new_velocity.normalized() * SPEED * delta
	
	apply_central_impulse(new_velocity)

func update_target_location(target_location):
	nav_agent.target_position = target_location
