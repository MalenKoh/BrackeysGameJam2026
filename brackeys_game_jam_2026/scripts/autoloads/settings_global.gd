extends Node

var master_volume: int:
	set (new_volume):
		var new_volume_db: int = linear_to_db(new_volume)
		AudioServer.set_bus_volume_db(master_bus, new_volume_db)
var background_volume: int:
	set (new_volume):
		var new_volume_db: int = linear_to_db(new_volume)
		AudioServer.set_bus_volume_db(music_bus, new_volume_db)
var sfx_volume: int:
	set (new_volume):
		var new_volume_db: int = linear_to_db(new_volume)
		AudioServer.set_bus_volume_db(sfx_bus, new_volume_db)
var crt_effects: bool:
	set (enabled):
		pass
var master_bus: int
var music_bus: int
var sfx_bus: int
func _ready() -> void:
	master_bus = AudioServer.get_bus_index("Master")
	music_bus = AudioServer.get_bus_index("Music")
	sfx_bus = AudioServer.get_bus_index("SFX")
	
func _process(_delta: float) -> void:
	pass
