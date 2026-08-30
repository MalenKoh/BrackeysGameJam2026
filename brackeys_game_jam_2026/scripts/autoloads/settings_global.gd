extends Node

var master_volume: float = 50:
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

func _ready() -> void:
	master_bus = AudioServer.get_bus_index("Master")
	music_bus = AudioServer.get_bus_index("Music")
	sfx_bus = AudioServer.get_bus_index("SFX")
