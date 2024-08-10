extends Node

# Get sound refference
@onready var hit = $Hit

# Get prop node on import
@onready var prop = $Node

# Get timer reference
@onready var timer = $Timer
var play_sound = false

func _ready():
	prop.body_entered.connect(_on_body_entered)
	prop.continuous_cd = true
	prop.can_sleep = true
	prop.max_contacts_reported = 300
	prop.contact_monitor = true
	
func _process(delta):
	hit.position = prop.position
	if timer.time_left == 0:
		play_sound = true

func pick_up(prop_interact: Prop_Interact):
	prop.freeze = true
	prop.freeze = false
	$".".global_rotation_degrees = Vector3(0, prop_interact.prop_rotation_degrees_y, 0)
	prop.global_position = prop_interact.prop_position
	prop.collision_mask = 13

func throw(prop_interact):
	prop.freeze = true
	prop.freeze = false
	prop.apply_central_impulse((prop_interact.prop_aim_direction * prop_interact.prop_throw_speed) + prop_interact.prop_aim_direction_y)
	#print((prop_interact.prop_aim_direction * prop_interact.prop_throw_speed) + prop_interact.prop_aim_direction_y)
	prop.collision_mask = 15

func _on_body_entered(body):
	print(body)
	#Lock on
	if body.get_parent().has_method("node_hit"):
		body.get_parent().node_hit()
	#Hit Frank
	if body.name == "Enemy":
		body.frank_hit()
	
	if play_sound:	
		hit.pitch_scale = randf_range(0.98, 1.02)
		hit.play()
