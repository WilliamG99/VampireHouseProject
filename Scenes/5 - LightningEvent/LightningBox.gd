extends MeshInstance3D

func _ready() -> void:
	$".".material = StandardMaterial3D
	$".".cast_shadow = false

func build_material() -> StandardMaterial3D:
	var mat = StandardMaterial3D.new()
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	var grad = Gradient.new()
	grad.set_color(0, Color(1,1,0,0.2))
	grad.set_color(1, Color(1, 1, 0, 0.0))
	var grad_tex = GradientTexture2D.new()
	grad_tex.gradient = grad
	grad_tex.fill_from = Vector2(0.0, 0.0)
	grad_tex.fill_to = Vector2(0.0, 0.5 * 1)
	mat.albedo_texture = grad_tex
	return mat
