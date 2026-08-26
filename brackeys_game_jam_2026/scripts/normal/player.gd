extends Node2D
class_name Player

const SPEED: int = 75

@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	PlayerGlobal.player = self

func _process(_delta: float) -> void:
	interact()
	choose_item()
	drop_item()
	
func _physics_process(delta: float) -> void:
	var delta_speed = SPEED * delta
	
	if Input.is_action_pressed("move_left"):
		position.x -= delta_speed
	elif Input.is_action_pressed("move_right"):
		position.x += delta_speed
	elif Input.is_action_pressed("move_up"):
		position.y -= delta_speed
	elif Input.is_action_pressed("move_down"):
		position.y += delta_speed
	
func drop_item() -> void:
	if !Input.is_action_just_pressed("drop_item"): return
	
	PlayerGlobal.drop_item()
	
func choose_item() -> void:
	if !Input.is_anything_pressed(): return
	var key : int = -1
	
	for i in range(PlayerGlobal.max_items):
		if (Input.is_key_pressed(KEY_1+i)):
			key = i
			
			break
	if key == -1: return
	
	PlayerGlobal.swap_item(key)
	
func interact() -> void:
	if !Input.is_action_just_pressed("interact"): return
	
	var distance : float
	var nearest_item : DroppedItem
	
	for area : Area2D in area_2d.get_overlapping_areas():
		var local_dist : float = (global_position - area.global_position).length() 
		if (!distance || local_dist < distance):
			distance = local_dist
			nearest_item = area.get_parent()
	
	if nearest_item:
		PlayerGlobal.add_to_inventory(nearest_item)
