extends Node2D 
class_name DroppedItem

@export_category("Item")
@export var resource : ItemResource

#ready
@onready var tooltip: Control = $Tooltip
@onready var item_sprite: TextureRect = $ItemSprite

func _ready() -> void:
	item_sprite.texture = resource.item_sprite
	
func _on_area_2d_area_entered(_area: Area2D) -> void:
	tooltip.visible = true

func _on_area_2d_area_exited(_area: Area2D) -> void:
	tooltip.visible = false
