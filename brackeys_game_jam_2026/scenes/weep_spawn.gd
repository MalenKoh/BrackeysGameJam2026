extends Node2D

@onready var timer: Timer = $Timer
@onready var spawn_1: Node2D = $Spawn1
@onready var spawn_2: Node2D = $Spawn2

var min_time: float = 10
var max_time: float = 15

var weeping_angel : WeepingAngel

const WEEPYANGEL = preload("uid://bq6o3mrgrce8w")

func summon_weeping_angel(spawn:Node2D) -> void:
	weeping_angel = WEEPYANGEL.instantiate()
	
	get_tree().current_scene.add_child(weeping_angel)
	
	weeping_angel.global_position = spawn.global_position
	weeping_angel.on_touched_player.connect(weeping_angel_death.bind(spawn))

func weeping_angel_death(spawn:Node2D) -> void:
	weeping_angel.on_touched_player.disconnect(weeping_angel_death)
	timer.start(randf_range(min_time, max_time))
	await timer.timeout
	summon_weeping_angel(spawn)
	
func _on_door_23_door_open() -> void:
	summon_weeping_angel(spawn_1)

func _on_door_26_door_open() -> void:
	summon_weeping_angel(spawn_2)

func _on_door_24_door_open() -> void:
	if !weeping_angel:
		return
	weeping_angel.on_touched_player.disconnect(weeping_angel_death)
	weeping_angel.queue_free()
