extends BaseItem
var world : World

const PILLS_CONSUME = preload("uid://dudg4jtbtwit4")

func _ready() -> void:
	world = get_tree().current_scene
	
func _on_item_used() -> void:
	world.add_sanity(20)
	AudioHandler.create_temporary_audio(PlayerGlobal.player, PILLS_CONSUME, 0, 1, "SFX")
	PlayerGlobal.remove_item(PlayerGlobal.current_key)
	PlayerGlobal.add_monologue("I feel lighter!")
	self.queue_free()
