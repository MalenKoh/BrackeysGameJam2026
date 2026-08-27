extends StaticBody2D
class_name Door

@export_category("Door Info")
@export var door_code : int

@onready var light_occluder_2d: LightOccluder2D = $LightOccluder2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var open : bool = false
var player_on_door : bool = false

func _on_player_range_area_entered(_area: Area2D) -> void:
	player_on_door = true

func _on_player_range_area_exited(_area: Area2D) -> void:
	player_on_door = false

func _input(_event: InputEvent) -> void:
	if !open && Input.is_action_just_pressed("interact") && player_on_door:
		var item_held : BaseItem = PlayerGlobal.get_held_item()
		
		if item_held && item_held.resource is KeyResource && item_held.resource.door_code == door_code:
			open = true
			light_occluder_2d.visible = false
			collision_shape_2d.disabled = true
			PlayerGlobal.remove_item(PlayerGlobal.current_key)
