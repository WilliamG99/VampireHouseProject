extends Node2D

@onready var label = $Label
@onready var timer = $Timer
@onready var total_time_seconds : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start()


func _on_timer_timeout():
	print(total_time_seconds)
	total_time_seconds += 1
	var min = int(total_time_seconds / 60)
	var sec = total_time_seconds - min * 60
	
	label.text = '%02d:%02d' % [min,sec]
