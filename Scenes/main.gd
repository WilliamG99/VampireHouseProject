extends Node3D

@onready var player = $Player
@onready var player_twist_pivot = $Player/TwistPivot
@onready var player_hand = $Player/TwistPivot/HoldingPoint
@onready var player_raycast = $Player/TwistPivot/PitchPivot/Camera3D/RayCast3D
@onready var enemy = $Enemy
@onready var pan = $FryingPan

var near_pan := false
var holding_pan := false

func _physics_process(delta):
	enemy.update_target_location(player.global_transform.origin)
	
	if near_pan and Input.is_action_just_pressed("interact"):
		print("true")
		print("Player picks up item")
		
		holding_pan = true
	
	
	if holding_pan:
		pan.freeze = true
		pan.global_rotation_degrees = Vector3(270, player_twist_pivot.global_rotation_degrees.y, 90)
		pan.global_position = player_hand.global_position
		
		#Camera Raycast
		var current_cast_result = player_raycast.get_collider()
		var camera_raycast_collision = player_raycast.get_collision_point()
		print(current_cast_result)
		print(camera_raycast_collision)
		
		if Input.is_action_just_pressed("throw"):
			holding_pan = false
			pan.freeze = false
			
			var velocity = (camera_raycast_collision - player_hand.global_position).normalized() * 2000 * delta
			pan.apply_central_impulse(velocity)


func _on_light_switch_body_entered(body):
	print(body)
	if %"Light Source".visible:
		print("Lights Off")
		%"Light Source".visible = false
	else:
		print("Lights On!")
		%"Light Source".visible = true

func _on_light_switch_2_body_entered(body):
	print(body)
	if %"Light Source2".visible:
		print("Lights Off")
		%"Light Source2".visible = false
	else:
		print("Lights On!")
		%"Light Source2".visible = true



func _on_area_3d_body_entered(body):
	if body == $Player:
		print("Player is near pan!")
		near_pan = true

func _on_area_3d_body_exited(body):
	if body == $Player:
		print("Player is away from pan!")
		near_pan = false
