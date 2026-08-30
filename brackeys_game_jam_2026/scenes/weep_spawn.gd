extends Node2D

@onready var timer: Timer = $Timer

var min_time: float = 10
var max_time: float = 15

var weeping_angel : WeepingAngel

const WEEPYANGEL = preload("uid://bq6o3mrgrce8w")

func summon_weeping_angel() -> void:
	weeping_angel = WEEPYANGEL.instantiate()
	
	get_tree().current_scene.add_child(weeping_angel)
	
	weeping_angel.global_position = global_position
	weeping_angel.on_touched_player.connect(weeping_angel_death)

func weeping_angel_death() -> void:
	weeping_angel.on_touched_player.disconnect(weeping_angel_death)
	timer.start(randf_range(min_time, max_time))
	await timer.timeout
	summon_weeping_angel()
	
func _on_door_23_door_open() -> void:
	summon_weeping_angel()
