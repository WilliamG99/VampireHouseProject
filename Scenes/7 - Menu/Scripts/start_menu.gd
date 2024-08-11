extends Control

# Get music reference
@onready var music = $Audio/Music
# Get SFX References
@onready var click = $Audio/Click
@onready var select = $Audio/Select

# Get credits reference
@onready var credits = $Credits

var start_game = false
var quit_game = false
var goto_credits = false

func _ready():
	credits.visible = false

func _on_button_start_pressed():
	# Play SFX
	click.play()
	# Update bool
	start_game = true

func _on_button_quit_pressed():
	# Play SFX
	click.play()
	# Update bool
	quit_game = true


func _on_click_finished():
	if start_game:
		# Reset bool
		start_game = false
		# Start the game
		print("start_menu.gd::10::START_BUTTON_PRESSED")
		print("Starting the game.")
		get_tree().change_scene_to_file("res://Scenes/test_level.tscn")		
	if quit_game:
		# Close the window
		print("start_menu.gd::35::QUIT_BUTTON_PRESSED")
		print("Closing the game.")
		get_tree().quit()
	if goto_credits:
		credits.visible = true
		goto_credits = false
		

# ************************
# HANDLE SOUNDS
# ************************

# Loops the music
func _on_music_finished():
	# Restart music
	music.play()

func _on_button_start_mouse_entered():
	# Play SFX
	select.play()

func _on_button_quit_mouse_entered():
	# Play SFX
	select.play()


func _on_credits_return_from_credits():
	credits.visible = false


func _on_button_credits_pressed():
	click.play()
	goto_credits = true


func _on_button_credits_mouse_entered():
	# Play SFX
	select.play()
