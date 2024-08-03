extends Node3D

var is_locked_on = preload("res://Scenes/8 - LockOn/is_locked_on.tscn")
var is_locked_instance = is_locked_on.instantiate()

func _is_locked_on():
	print("Locked")
	if !has_node("IsLockedOn"):
		add_child(is_locked_instance)

func _is_locked_off():
	print("Locked Off")
	if has_node("IsLockedOn"):
		remove_child(is_locked_instance)

func node_hit():
	print("node_hit")
