extends Node2D
class_name BaseItem

@export_category("Item Information")
@export var resource : ItemResource
@export var item_active : bool = true:
	set(value):
		item_active = value
		visible = value

func _physics_process(_delta: float) -> void:
	if (item_active && Input.is_action_just_pressed("use_item")):
		_on_item_used()

func _on_item_used() -> void:
	pass
