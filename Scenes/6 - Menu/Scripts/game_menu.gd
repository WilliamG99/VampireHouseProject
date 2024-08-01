extends Control

# Signal that indicates that Resume button was pressed
signal resume()

func _on_button_exit_pressed():
	# Close the game
	print("game_menu.gd::8::EXIT_BUTTON_PRESSED")
	print("Closing the game.")
	get_tree().quit()

func _on_button_resume_pressed():
	# Emit signal to main.gd
	print("game_menu.gd::14::RESUME_BUTTON_PRESSED")
	print("Closing te game menu.")
	resume.emit()

func _on_button_return_pressed():
	print("game_menu.gd::20::RETURN_BUTTON_PRESSED")
	print("Returning to title screen.")
	# Return to title scene
	get_tree().change_scene_to_file("res://Scenes/6 - Menu/Scenes/start_menu.tscn")