extends Control

# Get button refferences
@onready var button_start = $Padding/HorizontalAlligment/VerticalAllignment/ButtonStart
@onready var button_quit = $Padding/HorizontalAlligment/VerticalAllignment/ButtonQuit

# Preload the level
@onready var start_level = preload("res://Scenes/level.tscn")

# Get music reference
@onready var music = $Music

func _ready():
	print("READY")

func _process(delta):
	print("PROCESS")

func _on_music_finished():
 	# Start the music again
	music.play()

func _on_button_start_pressed():
	# Stop the music
	music.stop()
	
	print("start_menu.gd::22::START_BUTTON_PRESSED")
	print("Starting the game.")
	
	#  Change to level scene
	get_tree().change_scene_to_packed(start_level)

func _on_button_quit_pressed():
	print("start_menu.gd::29::QUIT_BUTTON_PRESSED")
	print("Closing the game.")
	
	# Close the game
	get_tree().quit()
