extends Node2D
class_name Player

const SPEED: int = 50

@onready var area_2d: Area2D = $Area2D
@onready var flashlight: Node2D = $Flashlight

func _process(_delta: float) -> void:
	rotate_flashlight()
	
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
		
	interact()
	
func interact() -> void:
	if !Input.is_action_just_pressed("interact"): return
	
	var distance : float
	var nearest_item : BaseItem
	
	for area : Area2D in area_2d.get_overlapping_areas():
		var local_dist : float = (global_position - area.global_position).length() 
		if (!distance || local_dist < distance):
			print("a")
			distance = local_dist
			nearest_item = area.get_parent()
	
	print(nearest_item)
	if nearest_item:
		PlayerGlobal.add_to_inventory(nearest_item)
		
func rotate_flashlight():
	flashlight.global_rotation = calculate_rot_angle()

func calculate_rot_angle() -> float:
	var offset: Vector2 = get_global_mouse_position() - global_position
	var angle: float = offset.angle()
	angle -= PI / 2
	return angle
