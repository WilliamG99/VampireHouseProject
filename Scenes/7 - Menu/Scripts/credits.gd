extends Control

signal return_from_credits

@onready var click = $Audio/Click
@onready var select = $Audio/Select

func _on_button_quit_pressed():
	click.play()


func _on_click_finished():
	return_from_credits.emit()
