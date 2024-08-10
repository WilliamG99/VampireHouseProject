extends Node3D

@onready var light_source = $LightSource
@onready var switch_sound = $SwitchSound
@onready var light_switch = $LightSwitch

@export var length: float = 13
@export var angle: float = 25
@export_range(0.0, 1.0, 0.01) var falloff: float = 1.0
@export_range(0.0, 1.0, 0.01) var opacity: float = 0.1

var light_set_once : bool

func _ready():
	light_set_once = false
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
	if !has_node("LightSource") and !light_set_once:
		add_child(light_source)
		light_set_once = true

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
			
		elif !has_node("LightSource"):
			switch_sound.play()
			add_child(light_source)
