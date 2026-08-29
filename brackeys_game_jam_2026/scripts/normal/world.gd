extends Node2D
class_name World

@onready var canvas_modulate: CanvasModulate = $ShadowAffected/CanvasModulate
@onready var world_environment: WorldEnvironment = $ShadowAffected/WorldEnvironment
@onready var clarity_timer: Timer = $ClarityTimer
@onready var tooltips: CanvasLayer = $Tooltips
@onready var floor_layer: TileMapLayer = $ShadowAffected/Floor

const TRANSITION_HEARTBEAT_INSANE = preload("uid://dlsk6asahqgv4")
const TRANSITION_TINNITUS_CLARITY = preload("uid://b32cowj2u3asa")
const SETTINGS_MENU = preload("res://scenes/UI/settings.tscn")

#sanity mechanic
var sane : bool = false
var clarity_min_time : float = 10
var clarity_max_time : float = 20
var player_sanity: int = 50:
	set(value):
		player_sanity = clampi(value, 0, 100)
		
		if (player_sanity == 100):
			shift_to_clarity()
		elif !sane:
			transition_crt(set_crt_effects(), 0.5, Tween.TRANS_ELASTIC)

var player : Player
var player_ui : PlayerUI
var crt_effect : ColorRect

#signals
signal update_sanity(sanity_to_add : int)
var settings_menu: Settings

signal clarity_begins()
signal insanity_begins()

var shader_params : Array[String] = [
	"crt_curve",
	"scanline_intensity",
	"crt_brightness",
	"crt_ghost",
	"crt_white_noise",
	"crt_grid",
	"vignette_multiplier",
]

var crt_clarity_values : Dictionary[String, float] = {
	"crt_curve" : 0.02,
	"scanline_intensity" : 0,
	"crt_brightness" : 1,
	"crt_ghost" : 0,
	"crt_white_noise" : 0,
	"crt_grid" : 0,
	"vignette_multiplier" : 0,
}

func _ready() -> void:
	player = PlayerGlobal.player
	player_ui = PlayerGlobal.player_UI
	crt_effect = player_ui.crt_effect
	
	update_sanity.connect(add_sanity)
	
func add_sanity(sanity_to_add : int) -> void:
	player_sanity += sanity_to_add
	#shift_to_clarity()
	
func _process(_delta: float) -> void:
	transition_crt(set_crt_effects(), 2, Tween.TRANS_BOUNCE)
	
	if Input.is_action_just_released("open_settings"):
		player_ui.add_child(SETTINGS_MENU.instantiate())

func shift_to_clarity() -> void:
	var tween = create_tween()
	
	transition_fake_objects("ffffff00", 0.5, Tween.TRANS_CUBIC)
	transition_crt(crt_clarity_values, 0.5, Tween.TRANS_CUBIC)
	player.camera_2d.position_smoothing_speed = 10
	
	tween.tween_property(canvas_modulate, "color", Color.from_string("a7a7a7", Color.WHITE), 0.5).set_trans(Tween.TRANS_CUBIC)
	world_environment.environment.glow_bloom = 0.5
	
	var tinnitus = AudioHandler.create_audio(player, TRANSITION_TINNITUS_CLARITY, 10, 1, "SFX")
	tinnitus.play()
	
	tween.set_parallel() 
	tween.tween_property(tinnitus, "volume_db", -70, 7).set_trans(Tween.TRANS_CIRC)
	
	AudioServer.set_bus_effect_enabled(1, 0, false)
	clarity_begins.emit()
	
	sane = true
	await tween.finished
	
	tinnitus.queue_free()
	
	clarity_timer.start(randf_range(clarity_min_time, clarity_max_time))
	
	await clarity_timer.timeout
	
	shift_to_insanity()
	
func shift_to_insanity() -> void:
	player_sanity = 50
	player.camera_2d.position_smoothing_speed = 1
	
	AudioServer.set_bus_effect_enabled(1, 0, true)
	
	transition_fake_objects("ffffff", 6, Tween.TRANS_BOUNCE)
	transition_crt(set_crt_effects(), 6, Tween.TRANS_BOUNCE)
	
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
	sane = false
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

func set_crt_effects() -> Dictionary[String, float]:
	var crt_values: Dictionary[String, float] = {
		"crt_curve" = max(0.15 - float(player_sanity) / 666.66, 0.03),
		"scanline_intensity" = max(1.0 - float(player_sanity) / 100.0, 0.15),
		"crt_brightness" = 0.5 + float(player_sanity) / 200.0,
		"crt_ghost" = max(1.1 - float(player_sanity) / 100.0, 0.2),
		"crt_white_noise" = max(0.25 - float(player_sanity) / 400.0, 0.05),
		"crt_grid" = float(player_sanity) / 100.0,
		"vignette_multiplier" = 2.0 / 3.0 - float(player_sanity) / 150.0,
	}
	return crt_values
