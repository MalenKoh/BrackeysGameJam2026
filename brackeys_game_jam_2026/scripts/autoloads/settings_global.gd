extends Node

const SETTINGS_MENU = preload("res://scenes/UI/settings.tscn")

var master_volume: float:
	set (new_volume):
		AudioServer.set_bus_volume_db(master_bus, new_volume)
var background_volume: float = 50:
	set (new_volume):
		AudioServer.set_bus_volume_db(music_bus, new_volume)
var sfx_volume: float = 50:
	set (new_volume):
		AudioServer.set_bus_volume_db(sfx_bus, new_volume)
var crt_effects: bool = true:
	set (enabled):
		pass
var master_bus: int
var music_bus: int
var sfx_bus: int

var settings_menu : Settings

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	master_bus = AudioServer.get_bus_index("Master")
	music_bus = AudioServer.get_bus_index("Music")
	sfx_bus = AudioServer.get_bus_index("SFX")

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("open_settings"):
		if !settings_menu:
			get_tree().paused = true
			settings_menu = SETTINGS_MENU.instantiate()
			
			PlayerGlobal.player_UI.add_child(settings_menu)
		else:
			settings_menu.queue_free()
			get_tree().paused = false
