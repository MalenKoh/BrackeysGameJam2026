extends CharacterBody2D

#Weeping Angel(light edition)
#Stops when flashlight

var WALKSPEED: int = 100
var flashed: bool = false
@export var player : Node2D
@onready var navAgent := $NavigationAgent2D as NavigationAgent2D
@onready var sprite := $AnimatedSprite2D as AnimatedSprite2D
@onready var timepath := $PathTimer as Timer
@onready var entity_sfx = $EntitySFX 
@onready var animation_player = $AnimationPlayer as AnimationPlayer

var globalp = preload("res://scripts/autoloads/player_global.gd")

func _ready() -> void:
	player = PlayerGlobal.player
	timepath.start() #starts the timer

func _physics_process(_delta: float) -> void:
	var walk_time : float = 0.05
	var walk_volume : float = -6
	var next_velocity : Vector2 = Vector2.ZERO
	var dir = to_local(navAgent.get_next_path_position()).normalized()
	var truepos = Vector2(player.position.x - self.position.x,player.position.y - self.position.y)
	var wah = sqrt((truepos.x*truepos.x) + (truepos.y*truepos.y)) #hypo?
	var ang = truepos.angle()
	#check if flashlight on
	if flashed || wah<12:
		#walking to player
		next_velocity=Vector2(0,0)
	else:
		next_velocity= dir*WALKSPEED
		sprite.rotation = ang + PI/2
	
	velocity = next_velocity
	
	if next_velocity != Vector2.ZERO:
		entity_sfx.play_footstep(walk_time, walk_volume)
		update_animation(true)
	else:
		update_animation(false)
	
	move_and_slide()

func update_animation(moving : bool) -> void:
	var next_animation : String = ""
		
	if !moving:
		next_animation = "Idle"
	else:
		next_animation = "Walking"
	
	
	if animation_player.current_animation == next_animation: return
	
	var animation_speed : float = 1.15
		
	animation_player.play(next_animation, 0, animation_speed)

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
