extends Node

@onready var path_to_follow: PathFollow2D = $Path2D/PathFollow_1 #in TrainChainManager

func _ready() -> void:
	path_to_follow.progress = 0 #in TrainChainManager

func _process(delta):
	pass
			


	
