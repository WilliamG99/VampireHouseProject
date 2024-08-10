extends Node3D

# Get node references
@onready var player = $Player
@onready var spring_arm_pivot = $Player/SpringArmPivot
@onready var enemy = $Enemy
@onready var game_menu = $UI/GameMenu
@onready var game_won_area = $GameWon


# Game paused state
var is_game_paused := false

func _ready():
	remove_child(game_won_area)
	# Make sure the game is unpaused
	Engine.time_scale = 1
	# Hide the game menu and the cursor at the start of the scene
	game_menu.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# When player chooses the resume option in game menu
func _on_game_menu_resume():
	# Start pause menu action
	gameMenu()

func _process(_delta):
	# **********************
	# HANDLE INPUT
	# **********************
	
	if Input.is_action_just_pressed("pause"):
		# Start pause menu action
		gameMenu()
		
	if Input.is_action_just_pressed("terminate"):
		print("main.gd::39::F1_KEYBOARD_BUTTON_PRESSED")
		print("Closing the game.")
		
		# Close the game
		get_tree().quit()
		

func gameMenu():
	# Swap paused state
	is_game_paused = !is_game_paused
		
	if is_game_paused:
		# Show the menu
		game_menu.show()
		# Pause the game
		Engine.time_scale = 0
		# Show the mouse
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		# Hide the menu
		game_menu.hide()
		# Unpause the game
		Engine.time_scale = 1
		# Hide the mouse
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Wake Frank
func _on_frank_trigger_body_entered(body):
	if body.name == "Player":
		$Enemy.set_frank_awake()
		get_tree().call_group("Lights", "turn_on_lights")
		add_child(game_won_area)


func _on_game_won_body_entered(body):
	if body.name == "Player":
		print("GAME WON!")
		get_tree().change_scene_to_file("res://Scenes/7 - Menu/Scenes/game_won.tscn")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
