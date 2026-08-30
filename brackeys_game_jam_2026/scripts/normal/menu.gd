extends Control

const SETTINGS_MENU = preload("res://scenes/UI/settings.tscn")

var settings_menu: Settings
var screen_width: int
var screen_height: int
var buttons: Array[TextureButton]

@onready var background: TextureRect = $Background
@onready var title: TextureRect = $Title
@onready var play: TextureButton = $Play
@onready var settings: TextureButton = $Settings
@onready var quit: TextureButton = $Quit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	settings_menu = SETTINGS_MENU.instantiate()
	screen_width = get_viewport_rect().size.x
	screen_height = get_viewport_rect().size.y
	buttons.append(play)
	buttons.append(settings)
	buttons.append(quit)
	
	background.size.x = screen_width
	background.size.y = screen_height
	title.size.x = screen_width * 7 / 8
	title.size.y = screen_height / 4
	title.position.x = screen_width / 18
	title.position.y = screen_height / 8
	for i in 3:
		buttons[i].size.x = screen_width / 2
		buttons[i].size.y = screen_height / 8
		buttons[i].position.x = screen_width / 4
		buttons[i].position.y = screen_height / 2 + i * screen_height / 6

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_settings_pressed() -> void:
	add_child(settings_menu)

func _on_quit_pressed() -> void:
	get_tree().quit()
