extends CanvasLayer
class_name PlayerUI

@onready var stamina: Control = $Stamina
@onready var hotbar_ui: Control = $Hotbar
@onready var h_box_container: HBoxContainer = $Hotbar/HBoxContainer
@onready var crt_effect: ColorRect = $CRTEffect
@onready var texture_progress_bar: TextureProgressBar = $Stamina/TextureProgressBar

const HOTBAR_SLOT = preload("uid://df11ujghokx6o")

var hotbar : Array[HotbarSlot]

func _ready() -> void:
	PlayerGlobal.player_UI = self
	
	for i : int in range(PlayerGlobal.max_items):
		var slot : HotbarSlot = HOTBAR_SLOT.instantiate()
		
		h_box_container.add_child(slot)
		hotbar.append(slot)
	
	select_slot(0)
	
	if PlayerGlobal.finished_intro:
		reveal_ui()

func select_slot(key : int) -> void:
	for slot : HotbarSlot in hotbar:
		slot.selected = false
		
	hotbar[key].selected = true

func update_item(key : int, item_texture : Texture2D) -> void:
	hotbar[key].update_item(item_texture)

func update_stamina(value : float) -> void:
	texture_progress_bar.value = value

func reveal_ui() -> void:
	stamina.visible = true
	hotbar_ui.visible = true
