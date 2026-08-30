extends AnimationPlayer

func _on_door_30_door_open() -> void:
	play("Ending", -1, 0.8)
	await animation_finished
	get_tree().change_scene_to_file("res://scenes/UI/menu.tscn")
