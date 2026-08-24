extends Node2D

var speed: int = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
