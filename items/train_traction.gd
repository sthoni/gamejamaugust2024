class_name TrainTraction extends Item

@export var brake_power := 1200.0
@export var transport_amount := 10.0

func apply_effects(target: Node) -> void:
	if target is Train:
		target.transport_amount += transport_amount
		target.brake_power += brake_power
