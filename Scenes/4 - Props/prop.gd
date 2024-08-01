extends RigidBody3D


func pick_up(prop_interact: Prop_Interact):
	global_rotation_degrees = Vector3(270, prop_interact.prop_rotation_degrees_y, 90)
	global_position = prop_interact.prop_position
	collision_mask = 13

func throw(prop_interact: Prop_Interact):
	apply_central_impulse(Vector3(0,20,0))
