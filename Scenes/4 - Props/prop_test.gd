extends Node

# Get sound refference
@onready var hit = $Hit

# Get prop node on import
@onready var prop = $Node

func _ready():
	prop.body_entered.connect(_on_body_entered)
	prop.continuous_cd = true
	prop.can_sleep = true
	
	# Set collision detection
	prop.max_contacts_reported = 5
	prop.contact_monitor = true
	
func _process(delta):
	# Update sound source position equal of props position
	hit.position = prop.position
	
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
	#Lock on
	if body.get_parent().has_method("node_hit"):
		body.get_parent().node_hit()
	#Hit Frank
	if body.name == "Enemy":
		body.frank_hit()
		
	hit.pitch_scale = randf_range(0.98, 1.02)
	hit.play()
