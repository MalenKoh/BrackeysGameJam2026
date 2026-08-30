@tool
extends StaticBody2D
class_name Door

@export_category("Door Info")
@export var door_code : int
@export var animation : String = "Standard_Door":
	set(value):
		animation = value
		update_animation()
@onready var light_occluder_2d: LightOccluder2D = $LightOccluder2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const CHARACTER_MONOLOGUE = preload("uid://bje2bac0yon0u")

var open : bool = false
var player_on_door : bool = false

func _ready() -> void:
	if $AnimationPlayer:
		update_animation()

func update_animation() -> void:
	var anim_player : AnimationPlayer = $AnimationPlayer
	
	if anim_player.has_animation(animation + "/door_closed"):
		anim_player.play(animation + "/door_closed")
	
func _on_player_range_area_entered(_area: Area2D) -> void:
	player_on_door = true
	
	var monologue : Monologue = CHARACTER_MONOLOGUE.instantiate()
	monologue.set_message("I need a key...")
	
	get_tree().current_scene.add_child(monologue)

func _on_player_range_area_exited(_area: Area2D) -> void:
	player_on_door = false

func _input(_event: InputEvent) -> void:
	if !open && Input.is_action_just_pressed("interact") && player_on_door:
		var item_held : BaseItem = PlayerGlobal.get_held_item()
		
		if item_held && item_held.resource is KeyResource && item_held.resource.door_code == door_code:
			open = true
			AudioHandler.create_temporary_audio(self, item_held.resource.unlock_sound, 0, 2, "SFX")
			PlayerGlobal.remove_item(PlayerGlobal.current_key)
			animation_player.play("Standard_Door/door_open")
