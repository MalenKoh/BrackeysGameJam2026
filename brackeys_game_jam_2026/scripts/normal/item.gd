extends Node2D
class_name BaseItem

@export_category("Item Information")
@export var resource : ItemResource
@export var item_active : bool = true:
	set(value):
		item_active = value
		visible = value

func _physics_process(_delta: float) -> void:
	rotate_item()
	
	if (item_active && Input.is_action_just_pressed("use_item")):
		_on_item_used()
	
func rotate_item() -> void:
	rotation = calculate_rot_angle()

func calculate_rot_angle() -> float:
	var offset: Vector2 = get_global_mouse_position() - global_position
	var angle: float = offset.angle()
	angle -= PI / 2
	return angle

func _on_item_used() -> void:
	pass
