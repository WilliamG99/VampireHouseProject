extends Node3D

@onready var player = $Player
@onready var character = $CharacterBody3D
@onready var enemy = $Enemy

func _physics_process(delta):
	#character.update_target_location(player.global_transform.origin)
	enemy.update_target_location(player.global_transform.origin)


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
