extends CharacterBody2D

var WALKSPEED: int = 100
var flashed: bool = false
@export var player : Node2D
@onready var navAgent := $NavigationAgent2D as NavigationAgent2D
@onready var sprite := $AnimatedSprite2D as AnimatedSprite2D
@onready var timepath := $PathTimer as Timer

var globalp = preload("res://scripts/autoloads/player_global.gd")

func _ready() -> void:
	player = PlayerGlobal.player
	timepath.start() #starts the timer

func _physics_process(_delta: float) -> void:
	var dir = to_local(navAgent.get_next_path_position()).normalized()
	var wah = navAgent.get_path_length()
	var ang = Vector2(player.position.x - self.position.x,player.position.y - self.position.y).angle()
	#check if flashlight on
	if flashed || wah<5:
		#walking to player
		velocity=Vector2(0,0)
	else:
		velocity= dir*WALKSPEED
		sprite.rotation = ang + PI/2
	move_and_slide()

func makePath() -> void:
	var xPos = player.global_position.x
	#this only works if you defined what is "walkable" using navigation layers
	navAgent.target_position = Vector2(xPos,player.global_position.y) #WHATTT


func _on_path_time_timeout() -> void:
	if(player!=null): 
		makePath()
	else: 
		print("no point")
	timepath.start()

func on_flashlight_enter(area: Area2D) -> void:
	#detecting layer 4 since only flashlight
	flashed = true


func on_flashlight_exit(area: Area2D) -> void:
	#detecting layer 4 since only flashlight
	flashed = false
