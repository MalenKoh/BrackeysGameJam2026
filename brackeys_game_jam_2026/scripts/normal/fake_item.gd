extends DroppedItem
class_name FakeItem

var distortion : Array[AudioStream]
var world : World
var interactable : bool = true

func _ready() -> void:
	super()
	
	world = get_tree().current_scene
	
	var directory : DirAccess = DirAccess.open("res://assets/audio/distortion/")
	
	if (!directory):
		push_warning("Room data could not be loaded!")
		return
		
	directory.list_dir_begin()
	
	for file : String in directory.get_files():
		if file.ends_with(".import"):
			file = file.trim_suffix(".import")
			
		var sound_file = load(directory.get_current_dir() + "/" + file)
		
		distortion.append(sound_file)
	
	world.clarity_begins.connect(on_clarity)
	world.insanity_begins.connect(on_insanity)
	
func on_clarity() -> void:
	interactable = false
	
func on_insanity() -> void:
	interactable = true
	
func vanish() -> void:
	if interactable:
		AudioHandler.create_temporary_audio(PlayerGlobal.player, distortion.pick_random(), -3, randf_range(0.3, 0.8), "SFX")
		world.add_sanity(-10)
		queue_free()
