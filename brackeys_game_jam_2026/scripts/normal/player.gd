extends CharacterBody2D
class_name Player

const SPEED: int = 75
const SPRINT_SPEED: int = 125
#children
@onready var area_2d: Area2D = $Area2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var entity_sfx: EntitySFX = $EntitySFX

func _ready() -> void:
	PlayerGlobal.player = self

func _process(_delta: float) -> void:
	look_at_mouse()
	
func _physics_process(_delta: float) -> void:
	var speed_magnitude : int = SPEED
	var next_speed : Vector2 = Vector2.ZERO
	var sprinting : bool = false
	var walk_time : float = 0.4
	var walk_volume : float = -5
	
	if Input.is_action_pressed("sprint"):
		walk_time = 0.2
		walk_volume = 4
		speed_magnitude = SPRINT_SPEED
		sprinting = true
		
	if Input.is_action_pressed("move_left"):
		next_speed = Vector2(-speed_magnitude, 0)
	elif Input.is_action_pressed("move_right"):
		next_speed = Vector2(speed_magnitude, 0)
	elif Input.is_action_pressed("move_up"):
		next_speed = Vector2(0, -speed_magnitude)
	elif Input.is_action_pressed("move_down"):
		next_speed = Vector2(0, speed_magnitude)
	
	velocity = next_speed
	
	if next_speed != Vector2.ZERO:
		entity_sfx.play_footstep(walk_time, walk_volume)
		update_animation(true, sprinting)
	else:
		update_animation(false, sprinting)
		
	move_and_slide()

func _input(_event: InputEvent) -> void:
	interact()
	choose_item()
	drop_item()
	
func update_animation(moving : bool, sprinting : bool) -> void:
	var next_animation : String = ""
	var animation_library : String = "None"
	var held_item : BaseItem = PlayerGlobal.get_held_item()
	
	#rint(held_item.resource)
	if held_item != null && held_item.resource.animation_library:
		animation_library = held_item.resource.animation_library
		
	if !moving:
		next_animation = animation_library + "/Idle"
	else:
		next_animation = animation_library + "/Walking"
	
	if animation_player.current_animation == next_animation: return
	
	var animation_speed : float = 1
	
	if sprinting:
		animation_speed = 2
		
	animation_player.play(next_animation, 0, animation_speed)
	
func look_at_mouse() -> void:
	var offset: Vector2 = get_global_mouse_position() - global_position
	var angle: float = offset.angle()
	angle += PI / 2
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
		if nearest_item is FakeItem:
			nearest_item.vanish()
			return
			
		PlayerGlobal.add_to_inventory(nearest_item)
