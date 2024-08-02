extends Node3D

# Get node references
@onready var player = $Player
@onready var player_mesh = $Player/MeshInstance3D
@onready var spring_arm_pivot = $Player/SpringArmPivot
@onready var player_hand = $Player/MeshInstance3D/PlayerHand
@onready var enemy = $Enemy
@onready var pan = $FryingPan
@onready var game_menu = $UI/GameMenu

var near_pan := false
var holding_pan := false

# Game paused state
var is_game_paused := false

func _ready():
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

func _physics_process(delta):
	enemy.update_target_location(player.global_transform.origin)
