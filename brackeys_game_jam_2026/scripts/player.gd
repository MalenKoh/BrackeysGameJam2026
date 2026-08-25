extends Node2D

var speed: int = 50
@onready var flashlight: Node2D = $Flashlight

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	rotate_flashlight()

func _physics_process(delta: float) -> void:
	var delta_speed = speed * delta
	if Input.is_action_pressed("move_left"):
		position.x -= delta_speed 
	elif Input.is_action_pressed("move_right"):
		position.x += delta_speed
	elif Input.is_action_pressed("move_up"):
		position.y -= delta_speed
	elif Input.is_action_pressed("move_down"):
		position.y += delta_speed

func rotate_flashlight():
	flashlight.global_rotation = calculate_rot_angle()

func calculate_rot_angle() -> float:
	var offset: Vector2 = get_global_mouse_position() - global_position
	var angle: float = offset.angle()
	angle -= PI / 2
	return angle
