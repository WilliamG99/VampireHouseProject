extends Node3D

# Get node references
@onready var player = $Player
@onready var player_mesh = $Player/MeshInstance3D
@onready var spring_arm_pivot = $Player/SpringArmPivot
@onready var player_hand = $Player/MeshInstance3D/PlayerHand
@onready var player_raycast = $Player/SpringArmPivot/SpringArm3D/Camera3D/RayCast3D
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

func _process(delta):
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
	
	if near_pan and Input.is_action_just_pressed("interact"):
		print("true")
		print("Player picks up item")
		holding_pan = true

	if holding_pan:
		pan.global_rotation_degrees = Vector3(270, player_mesh.global_rotation_degrees.y, 90)
		pan.global_position = player_hand.global_position
		pan.collision_mask = 13
		
		#Camera Raycast
		var current_cast_result = player_raycast.get_collider()
		var camera_raycast_collision = player_raycast.get_collision_point()

		if Input.is_action_just_pressed("throw"):
			holding_pan = false
			pan.freeze = false
			
			var velocity = (camera_raycast_collision - player_hand.global_position).normalized() * 1500 * delta
			pan.apply_central_impulse(velocity+Vector3(0,5,0))
			


func _on_light_switch_body_entered(body):
	if %"Light Source".visible:
		print("Lights Off")
		%"Light Source".visible = false
	else:
		print("Lights On!")
		%"Light Source".visible = true

func _on_light_switch_2_body_entered(body):
	if %"Light Source2".visible:
		print("Lights Off")
		%"Light Source2".visible = false
	else:
		print("Lights On!")
		%"Light Source2".visible = true



func _on_area_3d_2_body_entered(body):
	if body == $Player:
		print("Player is near pan!")
		near_pan = true

func _on_area_3d_2_body_exited(body):
	if body == $Player:
		print("Player is away from pan!")
		near_pan = false
		pan.collision_mask = 15
