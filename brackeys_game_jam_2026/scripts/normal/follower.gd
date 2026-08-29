extends PathFollow2D

#GUARD GUY
#NEEDS THE FOLLOWING NODES TO WORK:PATH2D, Follower
#AFTER MAKING A PATH AND MAKING Follower A CHILD OF PATH2D
#SET THE PATROL PATH TO FOLLOWER, or the follower of the specific path
#IT MOVES??
#IT FOLLOWS PLAYER WHEN IN VISION

@export var speed = 0.05
@export var ID:String
@onready var Rubert = $Rubert

func _ready() -> void:
	Rubert.name=ID

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if progress_ratio > 0.96: speed= -speed
	progress_ratio += delta * speed
