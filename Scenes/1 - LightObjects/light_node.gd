extends Node3D

@onready var light_source = $LightSource
@onready var switch_sound = $SwitchSound
@onready var light_switch = $LightSwitch

@onready var popup = %PopupInstructions
@onready var popup_timer = %InstructionTimer
var first_light_off_instructions : bool
var first_time_light_on : bool

@export var length: float = 13
@export var angle: float = 25
@export_range(0.0, 1.0, 0.01) var falloff: float = 1.0
@export_range(0.0, 1.0, 0.01) var opacity: float = 0.1

func _ready():
	first_light_off_instructions = false
	first_time_light_on = false
	if light_switch:
		switch_sound.position = light_switch.position

func get_length() -> float:
	return length

func get_angle() -> float:
	return angle

func get_falloff() -> float:
	return falloff

func get_opacity() -> float:
	return opacity

func turn_on_lights() -> void:
	if !has_node("LightSource") and !first_time_light_on:
		add_child(light_source)
		first_time_light_on = true

func _on_light_switch_body_entered(body : RigidBody3D):
	if body.has_method("get_desired_light_state"):
		if has_node("LightSource") and !body.get_desired_light_state():
			remove_child(light_source)
			switch_sound.play()
			
		elif !has_node("LightSource") and body.get_desired_light_state():
			switch_sound.play()
			add_child(light_source)
	else:
		if has_node("LightSource"):
			switch_sound.play()
			remove_child(light_source)
			
			if !first_light_off_instructions and $".".name == "BedroomDoorLight":
				first_light_off_instructions = true
				popup.text = """ Nice one! 
				Snacks are in the fridge
				And be careful not to alert Frank..."""
				popup_timer.start()
			
		elif !has_node("LightSource"):
			switch_sound.play()
			add_child(light_source)
