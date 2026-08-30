extends BaseItem
@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var point_light_2d_2: PointLight2D = $PointLight2D2

@onready var cpoly2d: CollisionPolygon2D = $Area2D/CollisionPolygon2D

const LIGHTSWITCH = preload("uid://cixnygsdeodjb")

func _on_item_used() -> void:
	if point_light_2d.enabled:
		AudioHandler.create_temporary_audio(self, LIGHTSWITCH, 0, 1.5, "SFX")
	else:
		AudioHandler.create_temporary_audio(self, LIGHTSWITCH, 0, 2, "SFX")
	
	point_light_2d.enabled = !point_light_2d.enabled
	point_light_2d_2.enabled = !point_light_2d_2.enabled
