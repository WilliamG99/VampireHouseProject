extends SpotLight3D

@export var length: float = 6.0
@export_range(0.0, 1.0, 0.01) var falloff: float = 1.0
@export_range(0.0, 1.0, 0.01) var opacity: float = 0.2


var _cone_mesh: MeshInstance3D = null
var _area3D: Area3D = null
var _cone_collision : CollisionShape3D = null


func _ready() -> void:
	_cone_mesh = MeshInstance3D.new()
	_area3D = Area3D.new()
	_cone_collision = CollisionShape3D.new()
	var cylinder = CylinderMesh.new()
	cylinder.material = build_material()

	_cone_mesh.mesh = cylinder
	_cone_mesh.cast_shadow = 0

	add_child(_cone_mesh)
	_cone_mesh.add_child(_area3D)
	update_position()
	update_cone()
	_cone_mesh.create_convex_collision()
	_area3D.add_child(_cone_collision)
	_cone_collision.shape = _cone_mesh.get_child(1).get_child(0).shape
	_area3D.collision_mask = 2
	
	_cone_mesh.get_child(1).queue_free()
	
	self._area3D.body_entered.connect(_on_body_entered)
	
func _on_body_entered(body):
	print(body.name)
	print("is inside the light!")
	
	if (body.name == "Player"):
		print("Is player")
		

func build_material() -> StandardMaterial3D:
	var mat = StandardMaterial3D.new()
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	var grad = Gradient.new()
	grad.set_color(0, Color(light_color, opacity))
	grad.set_color(1, Color(light_color, 0.0))
	
	var grad_tex = GradientTexture2D.new()
	grad_tex.gradient = grad
	grad_tex.fill_from = Vector2(0.0, 0.0)
	grad_tex.fill_to = Vector2(0.0, 0.5 * falloff)
	print("light_color", falloff)
	mat.albedo_texture = grad_tex
	return mat


func update_position() -> void:
	_cone_mesh.rotation.x = PI * 0.5
	_cone_mesh.position.z = length * -0.5


func update_cone() -> void:
	var a = deg_to_rad(spot_angle)
	var b = PI * 0.5
	var c = PI - (a + b)
	_cone_mesh.mesh.top_radius = 0.0
	_cone_mesh.mesh.bottom_radius = length * sin(a) / sin(c)
	_cone_mesh.mesh.height = length
