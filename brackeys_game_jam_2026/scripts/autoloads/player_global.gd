extends Node

var player : Player
var inventory_resources : Array[ItemResource]
var inventory_items : Array[BaseItem]
var current_key : int = 0
var max_items : int = 2

#preload
const DROPPED_ITEM = preload("uid://c1q3orxqixvmq")

func _ready() -> void:
	for i : int in range(max_items):
		inventory_items.append(null)
		inventory_resources.append(null)
		
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
		full_inventory()
		return
		
	inventory_resources[key] = item.resource
	item.queue_free()
	
	if key == current_key:
		equip_item(item.resource)

func swap_item(key : int) -> void:
	if (key == current_key): return

	if inventory_items[current_key] != null:
		inventory_items[current_key].item_active = false
	
	current_key = key
	
	if inventory_items[current_key] != null:
		inventory_items[current_key].item_active = true

func remove_item(key : int) -> void:
	inventory_resources[key] = null
	
	if key == current_key:
		inventory_items[current_key].queue_free()
		inventory_items[current_key] = null
		
func equip_item(item_resource : ItemResource) -> void:
	inventory_items[current_key] = item_resource.item_scene.instantiate()
	player.add_child(inventory_items[current_key])

func drop_item() -> void:
	if !inventory_items[current_key]: return
	var item_resource : ItemResource = inventory_resources[current_key]
	
	remove_item(current_key)
	
	var item_drop : DroppedItem = DROPPED_ITEM.instantiate()
	
	get_tree().current_scene.add_child(item_drop)
	
	item_drop.global_position = player.global_position
	item_drop.resource = item_resource
	
func full_inventory() -> void:
	pass
