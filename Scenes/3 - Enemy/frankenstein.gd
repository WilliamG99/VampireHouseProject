extends Node3D


func _on_animation_tree_animation_finished(anim_name):
	$AnimationTree.set("parameters/is_hit/transition_request", "false")