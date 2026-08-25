extends Node

var inventory : Array[ItemResource] = []
var held_item : int = 1
var max_items : int = 2

func add_to_inventory(item: BaseItem) -> void:
	print("YES")
	if (inventory.size() == max_items):
		full_inventory()
		return
	
	print("YES")
	inventory.append(item.resource)
	item.queue_free()

func full_inventory() -> void:
	pass
