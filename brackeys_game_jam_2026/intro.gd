extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if PlayerGlobal.finished_intro:
		queue_free()
	animation_player.play("Intro_Start",-1, 2)
	await animation_player.animation_finished
	PlayerGlobal.intro_finished.emit()
	PlayerGlobal.finished_intro = true
	
	queue_free()
