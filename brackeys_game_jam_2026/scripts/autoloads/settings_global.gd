extends Node

const SETTINGS_MENU = preload("res://scenes/UI/settings.tscn")

var master_volume: float:
	set (new_volume):
		master_volume = new_volume
		AudioServer.set_bus_volume_db(master_bus, new_volume)
var background_volume: float:
	set (new_volume):
		background_volume = new_volume
		AudioServer.set_bus_volume_db(music_bus, new_volume)
var sfx_volume: float:
	set (new_volume):
		sfx_volume = new_volume
		AudioServer.set_bus_volume_db(sfx_bus, new_volume)
var crt_effects: bool:
	set (enabled):
		crt_effects = enabled
var master_bus: int
var music_bus: int
var sfx_bus: int

var settings_menu : Settings

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	master_volume = 0
	background_volume = 15
	sfx_volume = 15
	crt_effects = true
	
	master_bus = AudioServer.get_bus_index("Master")
	music_bus = AudioServer.get_bus_index("Music")
	sfx_bus = AudioServer.get_bus_index("SFX")
	
	AudioServer.set_bus_volume_db(master_bus, master_volume)
	AudioServer.set_bus_volume_db(music_bus, background_volume)
	AudioServer.set_bus_volume_db(sfx_bus, sfx_volume)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("open_settings"):
		if !settings_menu:
			get_tree().paused = true
			settings_menu = SETTINGS_MENU.instantiate()
			
			PlayerGlobal.player_UI.add_child(settings_menu)
		else:
			settings_menu.queue_free()
			get_tree().paused = false
