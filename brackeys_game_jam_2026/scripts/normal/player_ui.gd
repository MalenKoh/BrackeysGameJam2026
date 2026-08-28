extends CanvasLayer
class_name PlayerUI

@onready var h_box_container: HBoxContainer = $Control/HBoxContainer
@onready var crt_effect: ColorRect = $CRTEffect

const HOTBAR_SLOT = preload("uid://df11ujghokx6o")

var hotbar : Array[HotbarSlot]

func _ready() -> void:
	PlayerGlobal.player_UI = self
	
	for i : int in range(PlayerGlobal.max_items):
		var slot : HotbarSlot = HOTBAR_SLOT.instantiate()
		
		h_box_container.add_child(slot)
		hotbar.append(slot)
	
	select_slot(0)

func select_slot(key : int) -> void:
	for slot : HotbarSlot in hotbar:
		slot.selected = false
		
	hotbar[key].selected = true

func update_item(key : int, item_texture : Texture2D) -> void:
	hotbar[key].update_item(item_texture)
