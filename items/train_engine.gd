class_name TrainEngine extends Item

@export var acc_power := 400.0

func apply_effects(target: Node) -> void:
	if target is Train:
		target.acc_power += acc_power
