extends CharacterBody2D

#GUARD GUY
#NEEDS THE FOLLOWING NODES TO WORK:PATH2D, Follower
#AFTER MAKING A PATH AND MAKING Follower A CHILD OF PATH2D
#SET THE PATROL PATH TO FOLLOWER, or the follower of the specific path
#IT MOVES??
#IT FOLLOWS PLAYER WHEN IN VISION

var walkspeed: int = 70
var flashed: bool = false
var isHunting:bool = false
var target:Node2D 
var player:Node2D
var original_position : Vector2
var clarity : bool = false
var world : World
var respawning : bool = false

@export var patrolPath : Node2D
@onready var navAgent := $NavigationAgent2D as NavigationAgent2D
@onready var sprite := $AnimatedSprite2D as AnimatedSprite2D
@onready var area2d := $Area2D as Area2D
@onready var timepath := $PathTimer as Timer
@onready var huntpath := $HuntTimer as Timer
@onready var entity_sfx = $EntitySFX 
@onready var animation_player = $AnimationPlayer as AnimationPlayer
@onready var kill_radius: Area2D = $KillRadius
@onready var respawn: Timer = $Respawn

const WEEPYNURSE = preload("uid://deyls6loi5ec")

func _ready() -> void:
	world = get_tree().current_scene
	original_position = global_position
	
	player=PlayerGlobal.player
	timepath.start() #starts the time
	
	world.clarity_begins.connect(on_clarity)
	world.insanity_begins.connect(on_insanity)
	
	clarity = world.sane
	visible = !world.sane

func on_clarity() -> void:
	clarity = true
	
func on_insanity() -> void:
	clarity = false
	
func _physics_process(_delta: float) -> void:
	if clarity || respawning: return
	
	if !isHunting: 
		target=patrolPath #initally Patrol Mode
		walkspeed=80
		update_animation(false)
	else: 
		target=player
		walkspeed=100
		update_animation(true)
	
	if(target==null): target=player
	
	#the actual pathfinding process
	var next_velocity : Vector2 = Vector2.ZERO
	var walk_time : float = 0.3
	var walk_volume : float = -6.5
	var dir = to_local(navAgent.get_next_path_position()).normalized()
	var truepos = Vector2(target.position.x - self.position.x,target.position.y - self.position.y)
	var wah = sqrt((truepos.x*truepos.x) + (truepos.y*truepos.y)) #hypo?
	var ang = truepos.angle()

	if wah<12: #if the target is really close
		#walking to target
		next_velocity=Vector2(0,0)
	else:
		next_velocity= dir*walkspeed
		sprite.rotation = ang + PI/2
		area2d.rotation = ang + PI/2
	
	velocity = next_velocity
	
	if next_velocity != Vector2.ZERO:
		entity_sfx.play_footstep(walk_time, walk_volume)
	
	move_and_slide()

func update_animation(hunting:bool) -> void:
	var next_animation : String = ""
		
	if !hunting:
		next_animation = "Patrol"
	else:
		next_animation = "Hunt"
	
	if animation_player.current_animation == next_animation: return
	
	var animation_speed : float = 1.0

	animation_player.play(next_animation, 0, animation_speed)

func makePath() -> void:
	var xPos = target.global_position.x
	#this only works if you defined what is "walkable" using navigation layers
	navAgent.target_position = Vector2(xPos,target.global_position.y) #WHATTT

func _on_path_time_timeout() -> void:
	if(target!=null): 
		makePath()
	else: 
		print("no point")
	timepath.start()

func _on_hunt_timer_timeout() -> void:
	if area2d.has_overlapping_areas(): #if it sees someone after timer
		isHunting=true
		huntpath.start() #maybe error
	else: 
		isHunting=false

func _on_area_2d_area_entered(area: Area2D) -> void:
	isHunting=true

func _on_area_2d_area_exited(area: Area2D) -> void:
	huntpath.start() #starts a timer to check again

func _on_kill_radius_area_entered(area: Area2D) -> void:
	if !clarity:
		AudioHandler.create_temporary_audio(PlayerGlobal.player, WEEPYNURSE, 0, randf_range(2,3), "SFX")
		get_tree().current_scene.add_sanity(-35)
		global_position = original_position
		respawn.start(randf_range(4,7))
		respawning = true

func _on_respawn_timeout() -> void:
	respawning = false
