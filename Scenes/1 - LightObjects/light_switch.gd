extends Area3D

@onready var switch_off = $SwitchOff

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

	


func _on_light_node_switch_off():
	print("DRAGANE")
	switch_off.play()
