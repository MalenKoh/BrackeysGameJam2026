extends Node

var player : Player
var player_UI : PlayerUI
var world : World

var inventory_resources : Array[ItemResource]
var inventory_items : Array[BaseItem]
var current_key : int = 0
var max_items : int = 2
var monologue : Monologue
var finished_intro: bool = false

var player_stamina : float = 100 :
	set(value):
		player_stamina = clampf(value, 0, 100)
		player_UI.update_stamina(value)
		
#preload

const DROPPED_ITEM = preload("uid://c1q3orxqixvmq")
const DROP_ITEM = preload("uid://yeuxbbxhjv41")
const PLAYER_EQUIP = preload("uid://cgblsapcfsfa8")
const HOLD_ITEM = preload("uid://645sl3vcf6pa")
const CHARACTER_MONOLOGUE = preload("uid://bje2bac0yon0u")

signal intro_finished()

func _ready() -> void:
	intro_finished.connect(enable_ui)
	
	for i : int in range(max_items):
		inventory_items.append(null)
		inventory_resources.append(null)

func restart() -> void:
	for i : int in range(max_items):
		inventory_items[i] = null
		inventory_resources[i] = null
func enable_ui() -> void:
	player_UI.reveal_ui()

func add_monologue(text : String) -> void:
	if monologue:
		monologue.queue_free()
		
	monologue = CHARACTER_MONOLOGUE.instantiate()
	monologue.set_message(text)
	
	get_tree().current_scene.tooltips.add_child(monologue)
	
func get_held_item() -> BaseItem:
	return inventory_items[current_key]
	
func add_to_inventory(item: DroppedItem) -> void:
	var key : int = -1
	
	if inventory_resources[current_key] == null:
		key = current_key
	
	if key == -1:
		for i : int in range(max_items):
			if (inventory_resources[i] == null):
				key = i
				break
	
	if key == -1:
		add_monologue("I have too many items... (Q to drop)")
		return
	
	AudioHandler.create_temporary_audio(player, PLAYER_EQUIP, 0, 2, "SFX")
	
	player_UI.update_item(key, item.resource.item_sprite)
	
	inventory_resources[key] = item.resource
	item.queue_free()
	
	add_item(item.resource, key)
	
	if key != current_key:
		inventory_items[key].item_active = false
		
func swap_item(key : int) -> void:
	if (key == current_key): return

	if inventory_items[current_key] != null:
		inventory_items[current_key].item_active = false
	
	current_key = key
	
	if inventory_items[current_key] != null:
		inventory_items[current_key].item_active = true
		AudioHandler.create_temporary_audio(player, HOLD_ITEM, 0, 1.5, "SFX")
	
	player_UI.select_slot(key)
	
func remove_item(key : int) -> void:
	inventory_resources[key] = null
	player_UI.update_item(key, null)
	
	if key == current_key:
		inventory_items[current_key].queue_free()
		inventory_items[current_key] = null
		
func add_item(item_resource : ItemResource, key : int) -> void:
	inventory_items[key] = item_resource.item_scene.instantiate()
	inventory_items[key].resource = item_resource
	
	player.add_child(inventory_items[key])
	
	return
func drop_item() -> void:
	if !inventory_items[current_key]: return
	var item_resource : ItemResource = inventory_resources[current_key]
	
	remove_item(current_key)
	
	var item_drop : DroppedItem = DROPPED_ITEM.instantiate()
	
	AudioHandler.create_temporary_audio(player, DROP_ITEM, -10, 1.5, "SFX")
	
	item_drop.global_position = player.global_position
	item_drop.resource = item_resource
	get_tree().current_scene.add_child(item_drop)
