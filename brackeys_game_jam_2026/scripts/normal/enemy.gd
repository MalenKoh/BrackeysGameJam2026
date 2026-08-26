class_name EnemyC
extends CharacterBody2D

var WALKSPEED: int = 25
var flashed: bool = false
@export var point: Node2D
@onready var navAgent := $NavigationAgent2D as NavigationAgent2D
@onready var timepath := $PathTime as Timer

var globalp = preload("res://scripts/autoloads/player_global.gd")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	timepath.start() #starts the timer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var dir = to_local(navAgent.get_next_path_position()).normalized()
	var wah = navAgent.get_path_length()
	#check if flashlight on
	if !flashed:
		#walking to player
		if(wah>5):
			velocity= dir*WALKSPEED
		else:
			velocity= Vector2(0,0)
	move_and_slide()

func makePath() -> void:
	var pDir = (point.scale).x
	var xPos = point.global_position.x
	#this only works if you defined what is "walkable" using navigation layers
	navAgent.target_position = Vector2(xPos,point.global_position.y) #WHATTT

func _on_path_time_timeout() -> void:
	if(point!=null): 
		makePath()
	else: 
		print("no point")
	timepath.start()
