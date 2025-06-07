class_name TrainTraction extends Item

@export var brake_power: float = 30000.0
@export var transport_amount: float = 10.0

func apply_effects(target: Train) -> void:
	target.transport_amount += transport_amount
	target.brake_power += brake_power
