extends Node3D


func _on_light_switch_body_entered(body):

	if %"Light Source".visible:
		print("Lights Off")
		%"Light Source".visible = false
	else:
		print("Lights On!")
		%"Light Source".visible = true


func _on_light_switch_2_body_entered(body):
	if %"Light Source2".visible:
		print("Lights Off")
		%"Light Source2".visible = false
	else:
		print("Lights On!")
		%"Light Source2".visible = true
