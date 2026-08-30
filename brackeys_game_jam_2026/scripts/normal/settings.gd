extends Control

class_name Settings

var screen_width: int
var screen_height: int
var sliders: Array[HSlider]
var labels: Array[RichTextLabel]
var checkboxes: Array[Texture2D]

@onready var settings: Settings = $"."
@onready var settings_background: TextureRect = $SettingsBackground
@onready var exit_button: TextureButton = $ExitButton
@onready var crt_effects: TextureButton = $"CRT Effects"
@onready var master: HSlider = $Master
@onready var background_music: HSlider = $"Background Music"
@onready var sound_effects: HSlider = $"Sound Effects"
@onready var master_label: RichTextLabel = $"Master/RichTextLabel"
@onready var background_label: RichTextLabel = $"Background Music/RichTextLabel"
@onready var sfx_label: RichTextLabel = $"Sound Effects/RichTextLabel"
@onready var crt_label: RichTextLabel = $"CRT Effects/RichTextLabel"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_width = get_viewport_rect().size.x
	screen_height = get_viewport_rect().size.y
	sliders.append(master)
	sliders.append(background_music)
	sliders.append(sound_effects)
	labels.append(master_label)
	labels.append(background_label)
	labels.append(sfx_label)
	labels.append(crt_label)
	checkboxes.append(preload("res://assets/sprites/checkbox_check.png"))
	checkboxes.append(preload("res://assets/sprites/checkbox.png"))
	
	settings.size.x = screen_width * 0.75
	settings.size.y = screen_height * 2 / 3
	settings.position.x = screen_width / 8
	settings.position.y = screen_height / 6
	settings_background.size.x = screen_width * 0.75
	settings_background.size.y = screen_height * 2 / 3
	exit_button.size.x = screen_width / 16
	exit_button.size.y = screen_height / 12
	exit_button.position.x = settings.size.x - exit_button.size.x
	exit_button.position.y = 0
	for i in 3:
		sliders[i].size.x = screen_width / 3.2
		sliders[i].size.y = screen_height / 24
		sliders[i].position.x = settings.size.x * 19 / 48
		sliders[i].position.y = (i + 2) * screen_height / 12
	crt_effects.size.x = screen_width * 3 / 64
	crt_effects.size.y = screen_height / 16
	crt_effects.position.x = settings.size.x * 7 / 16
	crt_effects.position.y = settings.size.y * 97 / 160
	#for i in 5:
		#labels[i].add_theme_font_size_override("font_size", screen_width * 3 / 100)
	
	master.value = 100
	background_music.value = 100
	sound_effects.value = 100
	SettingsGlobal.master_volume = master.value
	SettingsGlobal.background_volume = background_music.value
	SettingsGlobal.sfx_volume = sound_effects.value
		
func _on_texture_button_pressed() -> void:
	get_tree().paused = false
	queue_free()

func _on_master_drag_ended(value_changed: bool) -> void:
	if value_changed:
		SettingsGlobal.master_volume = master.value

func _on_background_music_drag_ended(value_changed: bool) -> void:
	if value_changed:
		SettingsGlobal.background_volume = background_music.value

func _on_sound_effects_drag_ended(value_changed: bool) -> void:
	if value_changed:
		SettingsGlobal.sfx_volume = sound_effects.value
	
func _on_crt_effects_toggled(toggled_on: bool) -> void:
	if toggled_on:
		SettingsGlobal.crt_effects = true
		crt_effects.texture_normal = checkboxes[0]
	else:
		SettingsGlobal.crt_effects = false
		crt_effects.texture_normal = checkboxes[1]
