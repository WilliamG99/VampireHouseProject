extends RigidBody3D

# Get sound refference
@onready var hit = $Hit


func pick_up(prop_interact: Prop_Interact):
	global_rotation_degrees = Vector3(270, prop_interact.prop_rotation_degrees_y, 90)
	global_position = prop_interact.prop_position
	collision_mask = 13

func throw(prop_interact):
	apply_central_impulse((prop_interact.prop_aim_direction * prop_interact.prop_throw_speed) + prop_interact.prop_aim_direction_y)
	print((prop_interact.prop_aim_direction * prop_interact.prop_throw_speed) + prop_interact.prop_aim_direction_y)
	collision_mask = 15


func _on_body_entered(body):
	hit.pitch_scale = randf_range(0.98, 1.02)
	hit.play()
