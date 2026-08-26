extends Control
class_name HotbarSlot

const INVENTORY_SLOT_OFF = preload("uid://blrdtjwb5534u")
const INVENTORY_SLOT_ON = preload("uid://co1vvr5b4asu3")

@onready var frame: TextureRect = $Frame
@onready var item: TextureRect = $Frame/Item

var selected : bool = false:
	set(value):
		selected = value
		
		if (selected):
			frame.texture = INVENTORY_SLOT_ON
		else:
			frame.texture = INVENTORY_SLOT_OFF
			
func update_item(item_texture : Texture2D) -> void:
	item.texture = item_texture
