extends Control

const SETTINGS_MENU = preload("res://scenes/UI/settings.tscn")

var settings_menu: Settings;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	settings_menu = SETTINGS_MENU.instantiate();

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_settings_pressed() -> void:
	add_child(settings_menu)

func _on_quit_pressed() -> void:
	get_tree().quit()
