extends Node2D
class_name World

@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var world_environment: WorldEnvironment = $WorldEnvironment
@onready var clarity_timer: Timer = $ClarityTimer

const TRANSITION_HEARTBEAT_INSANE = preload("uid://dlsk6asahqgv4")
const TRANSITION_TINNITUS_CLARITY = preload("uid://b32cowj2u3asa")

var sane : bool = false
var player : Player
var player_ui : PlayerUI
var crt_effect : ColorRect

signal clarity_begins()
signal insanity_begins()

var shader_params : Array[String] = [
	"crt_curve",
	"scanline_intensity",
	"crt_brightness",
	"crt_ghost",
	"crt_white_noise"
]

var crt_clarity_values : Dictionary[String, float] = {
	"crt_curve" : 0.03,
	"scanline_intensity" : 0,
	"crt_brightness" : 1,
	"crt_ghost" : 0,
	"crt_white_noise" : 0,
}

var crt_insanity_values : Dictionary[String, float] = {
	"crt_curve" : 0.075,
	"scanline_intensity" : 1.0,
	"crt_brightness" : 0.85,
	"crt_ghost" : 0.2,
	"crt_white_noise" : 0.15,
}

func _ready() -> void:
	player = PlayerGlobal.player
	player_ui = PlayerGlobal.player_UI
	crt_effect = player_ui.crt_effect
	
	shift_to_clarity()
func shift_to_clarity() -> void:
	var tween = create_tween()
	
	transition_fake_objects("ffffff00", 0.5, Tween.TRANS_CUBIC)
	transition_crt(crt_clarity_values, 0.5, Tween.TRANS_CUBIC)
	
	tween.tween_property(canvas_modulate, "color", Color.from_string("a7a7a7", Color.WHITE), 0.5).set_trans(Tween.TRANS_CUBIC)
	world_environment.environment.glow_bloom = 0.5
	
	var tinnitus = AudioHandler.create_audio(player, TRANSITION_TINNITUS_CLARITY, 10, 1, "SFX")
	tinnitus.play()
	
	tween.set_parallel() 
	tween.tween_property(tinnitus, "volume_db", -70, 7).set_trans(Tween.TRANS_CIRC)
	AudioServer.set_bus_effect_enabled(1, 0, false)
	clarity_begins.emit()
	
	await tween.finished
	
	tinnitus.queue_free()
	
	clarity_timer.start(randi_range(1, 1))
	
	await clarity_timer.timeout
	
	shift_to_insanity()
	
func shift_to_insanity() -> void:
	AudioServer.set_bus_effect_enabled(1, 0, true)
	
	transition_fake_objects("ffffff", 6, Tween.TRANS_BOUNCE)
	transition_crt(crt_insanity_values, 6, Tween.TRANS_BOUNCE)
	
	var tween : Tween = create_tween()
	
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
	insanity_begins.emit()

func transition_fake_objects(modulate_value : String, time : float, transition_type : Tween.TransitionType) -> void:
	for object : Node2D in get_tree().get_nodes_in_group("Fake"):
		var tween : Tween = create_tween()
		
		tween.tween_property(object, "modulate", Color.from_string(modulate_value, Color.WHITE), time).set_trans(transition_type)

func transition_crt(dictionary_values : Dictionary, time : float, transition_type : Tween.TransitionType) -> void:
	for parameter : String in shader_params:
		var tween : Tween = create_tween()
		
		tween.tween_property(crt_effect.material, "shader_parameter/"+parameter, dictionary_values[parameter], time).set_trans(transition_type)
