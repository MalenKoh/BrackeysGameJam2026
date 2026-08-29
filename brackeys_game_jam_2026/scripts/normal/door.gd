extends StaticBody2D
class_name Door

@export_category("Door Info")
@export var locked_door : bool = true
@export var door_code : int
@export var animation : String = "Standard_Door":
	set(value):
		animation = value
		if is_node_ready():
			update_animation()
@export var connected_lights : Array[PointLight2D]
@export var unlock_sound : AudioStream = preload("uid://d0pshfe87qs6l")
@export var hint_message : String = "I need a key..."

@onready var light_occluder_2d: LightOccluder2D = $LightOccluder2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var open : bool = false
var player_on_door : bool = false

func _ready() -> void:
	update_animation()
	for light : PointLight2D in connected_lights:
				light.enabled = false
				
func update_animation() -> void:
	if animation_player.has_animation(animation + "/door_closed"):
		animation_player.play(animation + "/door_closed")
	
func _on_player_range_area_entered(_area: Area2D) -> void:
	player_on_door = true
	
	if locked_door && !open:
		PlayerGlobal.add_monologue(hint_message)

func _on_player_range_area_exited(_area: Area2D) -> void:
	player_on_door = false

func _input(_event: InputEvent) -> void:
	if !open && Input.is_action_just_pressed("interact") && player_on_door:
		var item_held : BaseItem = PlayerGlobal.get_held_item()
		
		if !locked_door || (item_held && item_held.resource is KeyResource && item_held.resource.door_code == door_code):
			open = true
			
			if locked_door:
				AudioHandler.create_temporary_audio(self, item_held.resource.unlock_sound, 0, 2, "SFX")
				PlayerGlobal.remove_item(PlayerGlobal.current_key)
				
			AudioHandler.create_temporary_audio(self, unlock_sound, -2, 2, "SFX")
			animation_player.play(animation + "/door_open")
			
			for light : PointLight2D in connected_lights:
				light.enabled = true
