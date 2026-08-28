extends Control
class_name Monologue

@onready var label: Label = $CenterContainer/Label

var player: Player

func set_message(text : String) -> void:
	$CenterContainer/Label.text = text
	
func _ready() -> void:
	player = PlayerGlobal.player
	
	var tween : Tween = create_tween()
	
	tween.tween_property(self, "modulate", Color.from_string("00000000", Color.WHITE), 3).set_trans(Tween.TRANS_CIRC)
	
	await tween.finished
	
	queue_free()

func _process(_delta: float) -> void:
	global_position = player.global_position
