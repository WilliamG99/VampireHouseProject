extends RigidBody3D


func pick_up(prop_interact: Prop_Interact):
	global_rotation_degrees = Vector3(270, prop_interact.prop_rotation_degrees_y, 90)
	global_position = prop_interact.prop_position
	collision_mask = 13

func throw(prop_interact):
	freeze = true
	freeze = false
	apply_central_impulse((prop_interact.prop_aim_direction * prop_interact.prop_throw_speed) + prop_interact.prop_aim_direction_y)
	collision_mask = 15


func _on_body_entered(body):
	if body.get_parent().has_method("node_hit"):
		body.get_parent().node_hit()
