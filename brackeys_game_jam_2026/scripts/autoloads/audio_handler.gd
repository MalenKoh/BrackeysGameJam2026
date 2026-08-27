extends Node

func create_temporary_audio(parent : Node, stream : AudioStream, volume : float, pitch : float, bus : StringName) -> void:
	var audiostream : AudioStreamPlayer = create_audio(parent, stream, volume, pitch, bus)
	
	audiostream.play()
	await audiostream.finished
	audiostream.queue_free()
	
func create_audio(parent : Node, stream : AudioStream, volume : float, pitch : float, bus : StringName) -> AudioStreamPlayer:
	var audiostream : AudioStreamPlayer = AudioStreamPlayer.new()
	
	audiostream.stream = stream
	audiostream.volume_db = volume
	audiostream.pitch_scale = pitch
	audiostream.bus = bus
	
	parent.add_child(audiostream)

	return audiostream
