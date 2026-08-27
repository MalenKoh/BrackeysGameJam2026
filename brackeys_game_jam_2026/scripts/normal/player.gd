extends Node2D
class_name Player

const SPEED: int = 75

#children
@onready var area_2d: Area2D = $Area2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var entity_sfx: EntitySFX = $EntitySFX

func _ready() -> void:
	PlayerGlobal.player = self

func _process(_delta: float) -> void:
	interact()
	choose_item()
	drop_item()
	look_at_mouse()
	
func _physics_process(delta: float) -> void:
	var delta_speed = SPEED * delta
	
	var moving : bool = true
	
	if Input.is_action_pressed("move_left"):
		position.x -= delta_speed
	elif Input.is_action_pressed("move_right"):
		position.x += delta_speed
	elif Input.is_action_pressed("move_up"):
		position.y -= delta_speed
	elif Input.is_action_pressed("move_down"):
		position.y += delta_speed
	else:
		moving = false
	
	if moving:
		entity_sfx.play_footstep()
		
	update_animation(moving)
	
func update_animation(moving : bool) -> void:
	var next_animation : String = ""
	
	if !moving:
		next_animation = "None/Idle"
	else:
		next_animation = "None/Walking"
	
	if animation_player.current_animation == next_animation: return
	animation_player.play(next_animation)
	
func look_at_mouse() -> void:
	var offset: Vector2 = get_global_mouse_position() - global_position
	var angle: float = offset.angle()
	angle -= PI / 2
	global_rotation = angle
	
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
