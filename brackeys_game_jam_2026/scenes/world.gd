extends Node2D
class_name World

@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var world_environment: WorldEnvironment = $WorldEnvironment
@onready var timer: Timer = $Timer

const TRANSITION_HEARTBEAT_INSANE = preload("uid://dlsk6asahqgv4")
const TRANSITION_TINNITUS_CLARITY = preload("uid://b32cowj2u3asa")

var sane : bool = false
var player : Player

func _ready() -> void:
	player = PlayerGlobal.player
	#shift_to_clarity()
	
func shift_to_clarity() -> void:
	var tween = create_tween()
	
	tween.tween_property(canvas_modulate, "color", Color.from_string("a7a7a7", Color.WHITE), 0.5).set_trans(Tween.TRANS_CUBIC)
	world_environment.environment.glow_bloom = 0.5
	
	var tinnitus = AudioHandler.create_audio(player, TRANSITION_TINNITUS_CLARITY, 10, 1, "SFX")
	tinnitus.play()
	
	tween.set_parallel() 
	tween.tween_property(tinnitus, "volume_db", -70, 7).set_trans(Tween.TRANS_CIRC)
	AudioServer.set_bus_effect_enabled(1, 0, false)
	await tween.finished
	#AudioServer.set_bus_effect_enabled(1, 0, false)
	
	tinnitus.queue_free()
	
	#timer.start()
	#await timer.timeout
	#shift_to_insanity()
	
func shift_to_insanity() -> void:
	AudioServer.set_bus_effect_enabled(1, 0, true)
	var tween = create_tween()
	
	tween.tween_property(canvas_modulate, "color", Color.BLACK, 6).set_trans(Tween.TRANS_BOUNCE)
	world_environment.environment.glow_bloom = 1
	
	var heart_beat = AudioHandler.create_audio(player, TRANSITION_HEARTBEAT_INSANE, -20, 2, "SFX")
	heart_beat.play()
	
	tween.set_parallel() #This is so that you can run this tween before waiting for the other tween to finish -note
	tween.tween_property(heart_beat, "pitch_scale", 6, 6).set_trans(Tween.TRANS_LINEAR)
	
	tween.set_parallel() 
	tween.tween_property(heart_beat, "volume_db", 10, 6).set_trans(Tween.TRANS_CIRC)
	
	await tween.finished
	heart_beat.stop()
	heart_beat.queue_free()
	
	#timer.start()
	#await timer.timeout
	
	#shift_to_clarity()
