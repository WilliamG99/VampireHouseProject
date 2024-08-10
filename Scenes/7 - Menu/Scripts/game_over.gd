extends Control

# Get button SFX references
@onready var click = $Audio/Click
@onready var select = $Audio/Select

# When click sound finishes, look according to bools what action to do
var send_retry_signal = false
var return_to_title = false
var exit = false

func _on_button_retry_pressed():
	# Play SFX
	click.play()
	# Set bool
	send_retry_signal = true

func _on_button_return_pressed():
	# Play SFX
	click.play()
	# Set bool 
	return_to_title = true

func _on_button_exit_pressed():
	# Play SFX
	click.play()
	# Set bool
	exit = true


func _on_click_finished():
	if send_retry_signal:
		# Reset bool
		send_retry_signal = false
		# Emit signal to main.gd
		print("game_over.gd::39::RETRY_BUTTON_PRESSED")
		print("Restarting Game")
		get_tree().change_scene_to_file("res://Scenes/test_level.tscn")
		
	if return_to_title:
		# Reset bool
		return_to_title = false
		# Return to title scene
		print("game_menu.gd::38::RETURN_BUTTON_PRESSED")
		print("Returning to title screen.")
		get_tree().change_scene_to_file("res://Scenes/7 - Menu/Scenes/start_menu.tscn")
		
	if exit:
		# Reset bool 
		exit = false
		# Close the game
		print("game_menu.gd::8::EXIT_BUTTON_PRESSED")
		print("Closing the game.")
		get_tree().quit()
		

func _on_button_retry_mouse_entered():
	select.play()

func _on_button_return_mouse_entered():
	select.play()

func _on_button_exit_mouse_entered():
	select.play()
