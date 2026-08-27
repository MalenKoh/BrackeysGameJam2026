extends Node2D
class_name EntitySFX

var footsteps_concrete : Array
var step_cd : bool = false

@onready var step: Timer = $Step

func _ready() -> void:
	var directory : DirAccess = DirAccess.open("res://assets/audio/footsteps/footsteps_concrete")
	
	if (!directory):
		push_warning("Room data could not be loaded!")
		return
		
	directory.list_dir_begin()
	
	for file : String in directory.get_files():
		if file.ends_with(".import"):
			file = file.trim_suffix(".import")
			
		var sound_file = load(directory.get_current_dir() + "/" + file)
		
		footsteps_concrete.append(sound_file)

func play_footstep() -> void:
	if step_cd: return
	
	step_cd = true
	step.start()
	
	AudioHandler.create_temporary_audio(self, footsteps_concrete.pick_random(), -5, randf_range(0.75, 2.1), "SFX")

func _on_step_timeout() -> void:
	step_cd = false
