@tool
extends Node2D 
class_name DroppedItem

@export_category("Item")
@export var resource : ItemResource:
	set(value):
		resource = value
		$ItemSprite.texture = value

#ready
var tooltip: Control

@onready var item_sprite: Sprite2D = $ItemSprite

const TOOLTIP = preload("uid://dvq8avv8h2xb7")

func _ready() -> void:
	if Engine.is_editor_hint(): return
	
	item_sprite.texture = resource.item_sprite
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	if !tooltip:
		tooltip = TOOLTIP.instantiate()
		tooltip.global_position = global_position
		get_tree().current_scene.tooltips.add_child(tooltip)
		
	if area.get_parent() is Player:
		tooltip.visible = true

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.get_parent() is Player:
		tooltip.visible = false
