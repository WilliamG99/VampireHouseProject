extends Control

# Get music reference
@onready var music = $Music

func _on_button_start_pressed():
	# Start the game
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_button_quit_pressed():
	# Close the window
	get_tree().quit()


# Loops the music
func _on_music_finished():
	music.play()
