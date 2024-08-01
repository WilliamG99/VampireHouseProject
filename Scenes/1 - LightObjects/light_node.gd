extends Node3D

@onready var light_source = $LightSource

func _on_light_switch_body_entered(body : RigidBody3D):
	
	if body.has_method("get_desired_light_state"):
		if has_node("LightSource") and !body.get_desired_light_state():
			remove_child(light_source)
			
		elif !has_node("LightSource") and body.get_desired_light_state():
			add_child(light_source)
			
		else:
			return
