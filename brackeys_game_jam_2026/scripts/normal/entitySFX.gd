extends Node2D
class_name EntitySFX

var step_cd : bool = false
var foot_steps : Dictionary[String, AudioStream] = {
	"Tile" : preload("res://assets/audio/footsteps/footstep_tile_1.mp3"),
	"Grass" : preload("res://assets/audio/footsteps/foot_step_grass_1.wav"),
	"Concrete" : preload("res://assets/audio/footsteps/footstep_concrete_1.wav"),
	"Vent" : preload("res://assets/audio/footsteps/footstep_vent_1.wav")
}

@onready var step: Timer = $Step

func play_footstep(time:float, volume : float) -> void:
	if step_cd: return
	
	step_cd = true
	step.start(time)
	
	var world : World = get_tree().current_scene
	var tile_type : String = world.floor_layer.get_cell_tile_data(world.floor_layer.local_to_map(global_position)).get_custom_data("Tile_Type")
	
	AudioHandler.create_temporary_audio(self, foot_steps[tile_type], volume, randf_range(0.75, 2.1), "SFX")

func _on_step_timeout() -> void:
	step_cd = false
