extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("Intro_Start",-1, 1500)
	await animation_player.animation_finished
	PlayerGlobal.intro_finished.emit()
	
	queue_free()
