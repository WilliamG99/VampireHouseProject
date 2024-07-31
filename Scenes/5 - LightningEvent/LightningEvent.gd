extends Node3D

@onready var lightning_node = $LightningEffect
@onready var lightning_timer = $LightningTimer
@onready var lightning_length_timer = $LightningLengthTimer


const TIMER_MAX := 5
const TIMER_MIN := 1


func _ready() -> void:
	print("READY!")
	
	remove_child(lightning_node)


func _on_timer_timeout():
	add_child(lightning_node)
	
	# Starts lightning length timer here
	lightning_length_timer.start()


func _on_lightning_length_timer_timeout():
	remove_child(lightning_node)
	
	# Set LightningTimer with random number
	lightning_timer.set_wait_time(randi() % TIMER_MAX + TIMER_MIN)


func _on_lightning_box_area_body_entered(body):
	if body == $Player:
		print(body.name, " detected")
