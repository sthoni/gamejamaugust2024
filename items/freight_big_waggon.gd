class_name FreightBigWaggon extends Item

@export var transport_amount: float = 80.0

func apply_effects(target: Node) -> void:
	if target is Train:
		target.weight += self.weight
		target.transport_amount += transport_amount
