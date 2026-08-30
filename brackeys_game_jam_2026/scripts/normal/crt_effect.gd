extends ColorRect

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	show() if SettingsGlobal.crt_effects else hide()
