extends Area3D

@onready var switch_off = $SwitchOff

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func play_sound(sound):
	if sound == "off":
		switch_off.play()
	elif sound == "on":
		switch_off.play()
