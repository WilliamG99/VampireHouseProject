extends Node3D


func _on_animation_tree_animation_finished():
	$AnimationTree.set("parameters/isHit/transition_request", "false")
