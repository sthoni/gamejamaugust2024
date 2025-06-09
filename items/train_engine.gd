class_name TrainEngine extends Item

@export var acc_power: float = 20000.0
@export var level: int = 1: set = change_level

func change_level(value: int) -> void:
	if value < 0:
		level = 0
	elif value > 5:
		level = 5
	else:
		level = value
