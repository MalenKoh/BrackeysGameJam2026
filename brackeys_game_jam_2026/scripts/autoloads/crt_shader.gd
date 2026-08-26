extends MeshInstance2D

var screen_width: float
var screen_height: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_width = get_viewport().size.x
	screen_height = get_viewport().size.y
	mesh.size = Vector2(screen_width, screen_height)
	mesh.set_center_offset(Vector3(screen_width / 2.0, screen_height / 2.0, 0.0))
	get_material().set_shader_parameter("screen_height", screen_height)
