extends Area3D



func _on_body_entered(body):
	if body.has_method("bedroom_reached"):
		body.bedroom_reached()
