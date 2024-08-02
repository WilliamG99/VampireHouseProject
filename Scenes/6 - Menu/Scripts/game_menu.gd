extends Control

# Signal that indicates that Resume button was pressed
signal resume

# Get button SFX references
@onready var click = $Audio/Click
@onready var select = $Audio/Select

# When click sound finishes, look according to bools what action to do
var send_resume_signal = false
var return_to_title = false
var exit = false

func _on_button_exit_pressed():
	# Play SFX
	click.play()
	# Set bool
	exit = true

func _on_button_resume_pressed():
	# Play SFX
	click.play()
	# Set bool
	send_resume_signal = true


func _on_button_return_pressed():
	# Play SFX
	click.play()
	# Set bool 
	return_to_title = true

func _on_click_finished():
	if send_resume_signal:
		# Reset bool
		send_resume_signal = false
		# Emit signal to main.gd
		print("game_menu.gd::14::RESUME_BUTTON_PRESSED")
		print("Closing te game menu.")
		resume.emit()
		
	if return_to_title:
		# Reset bool
		return_to_title = false
		# Return to title scene
		print("game_menu.gd::38::RETURN_BUTTON_PRESSED")
		print("Returning to title screen.")
		get_tree().change_scene_to_file("res://Scenes/6 - Menu/Scenes/start_menu.tscn")
		
	if exit:
		# Reset bool 
		exit = false
		# Close the game
		print("game_menu.gd::8::EXIT_BUTTON_PRESSED")
		print("Closing the game.")
		get_tree().quit()
		

func _on_button_resume_mouse_entered():
	select.play()

func _on_button_return_mouse_entered():
	select.play()

func _on_button_exit_mouse_entered():
	select.play()
