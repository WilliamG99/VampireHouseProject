extends Node

# Get sound refference
@onready var hit = $Hit

# Get prop node on import
@onready var prop = $Node

# First time picking up bedroom door to trigger instructios
@onready var bedroom_door_instructions := false
@onready var bedroom_door_thrown := false
@onready var popup = %PopupInstructions


func _ready():
	prop.body_entered.connect(_on_body_entered)
	prop.continuous_cd = true
	prop.can_sleep = true
	prop.freeze = true
	prop.freeze_mode = 1

func pick_up(prop_interact: Prop_Interact):
	prop.freeze = true
	prop.freeze = false
	prop.global_rotation_degrees = Vector3(0, prop_interact.prop_rotation_degrees_y, 0)
	prop.global_position = prop_interact.prop_position
	prop.collision_mask = 13
	
	if !bedroom_door_instructions and $".".name == "BedroomDoor":
		bedroom_door_instructions = true
		popup.text = """Oh, okay... We should hide that in our room
		At least put it down gently. Press 'LMB' """

func throw(prop_interact):
	prop.freeze = true
	prop.freeze = false
	prop.apply_central_impulse((prop_interact.prop_aim_direction * prop_interact.prop_throw_speed) + prop_interact.prop_aim_direction_y)
	#print((prop_interact.prop_aim_direction * prop_interact.prop_throw_speed) + prop_interact.prop_aim_direction_y)
	prop.collision_mask = 15
	
	if bedroom_door_instructions and !bedroom_door_thrown and $".".name == "BedroomDoor":
		bedroom_door_thrown = true
		popup.text = """Might aswell start throwing everything, why don't you?
		Pick up that basketball outside your room"""

func _on_body_entered(body):
	print(body)
	#Lock on
	if body.get_parent().has_method("node_hit"):
		body.get_parent().node_hit()
	#Hit Frank
	if body.name == "Enemy":
		body.frank_hit()
		
	hit.pitch_scale = randf_range(0.98, 1.02)
	hit.play()
