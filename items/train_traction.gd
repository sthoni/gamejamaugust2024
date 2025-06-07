class_name TrainTraction extends Item

@export var brake_power: float = 30000.0
@export var transport_amount: float = 10.0
@export var level: int = 1 : set = change_level

func apply_effects(target: Train) -> void:
	target.transport_amount += transport_amount
	target.brake_power = brake_power + ((level - 1) / 4.0) * brake_power

func change_level(value: int) -> void:
	if value < 0:
		level = 0
	elif value > 5:
		level = 0
	else:
		level = value
