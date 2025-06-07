class_name TrainEngine extends Item

@export var acc_power: float = 20000.0

func apply_effects(target: Train) -> void:
	target.acc_power += acc_power
