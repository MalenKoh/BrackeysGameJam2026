extends BaseItem
@onready var point_light_2d: PointLight2D = $PointLight2D

func _on_item_used() -> void:
	point_light_2d.enabled = !point_light_2d.enabled
