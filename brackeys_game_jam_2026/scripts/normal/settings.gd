extends Control

class_name Settings

@onready var master: HSlider = $Master
@onready var background_music: HSlider = $"Background Music"
@onready var sound_effects: HSlider = $"Sound Effects"
@onready var crt_checkbox: RichTextLabel = $"CRT Effects/RichTextLabel"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	master.value = 100
	background_music.value = 100
	sound_effects.value = 100
	
	SettingsGlobal.master_volume = master.value
	SettingsGlobal.background_volume = background_music.value
	SettingsGlobal.sfx_volume = sound_effects.value
	
func _on_texture_button_pressed() -> void:
	get_parent().remove_child(self)

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
		crt_checkbox.text = "✓"
	else:
		SettingsGlobal.crt_effects = false
		crt_checkbox.text = "X"
