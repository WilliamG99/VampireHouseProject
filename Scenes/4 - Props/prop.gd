extends RigidBody3D


func pick_up(prop_interact: Prop_Interact):
	global_rotation_degrees = Vector3(270, prop_interact.prop_rotation_degrees_y, 90)
	global_position = prop_interact.prop_position
	collision_mask = 0

func throw(prop_interact):
	print(-global_transform.basis.z.normalized())
	print(prop_interact.prop_aim_direction)
	apply_central_impulse(prop_interact.prop_aim_direction * 100)
	collision_mask = 0
