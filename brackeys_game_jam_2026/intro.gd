extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("Intro_Start",-1, 2)
	get_tree().paused = true
	await animation_player.animation_finished
	PlayerGlobal.intro_finished.emit()
	get_tree().paused = false
	queue_free()
