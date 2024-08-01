extends Node3D


@onready var player = $Player
@onready var enemy = $Enemy


func _physics_process(delta):
	# Sends player locations to enemy navigation agent
	enemy.update_target_location(player.global_transform.origin)
