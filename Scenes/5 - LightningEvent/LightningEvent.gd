extends Node3D

@onready var lightning_node = $LightningEffect
@onready var lightning_timer = $"../LightningTimer"
@onready var lightning_length_timer = $"../LightningLengthTimer"

# Get sounds FX refference
@onready var thunder = $Thunder

const TIMER_MAX := 6
const TIMER_MIN := 3


func _ready() -> void:
	print("READY!")
	
	remove_child(lightning_node)


func _on_lightning_timer_timeout():
	add_child(lightning_node)
	
	# Starts lightning length timer here
	lightning_length_timer.start()
	
	# PLay sound effect
	thunder.play()


func _on_lightning_length_timer_timeout():
	remove_child(lightning_node)
	
	# Set LightningTimer with random number
	lightning_timer.set_wait_time(randi() % TIMER_MAX + TIMER_MIN)


func _on_lightning_box_area_body_entered(body):
	if body.has_method("in_lightning"):
		print("IN LIGHTNING")
		body.in_lightning()

func _on_lightning_box_area_body_exited(body):
	if body.has_method("out_lightning"):
		print("OUT LIGHTNING")
		body.out_lightning()
