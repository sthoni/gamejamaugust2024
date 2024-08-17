class_name FreightWaggon extends Item

@export var transport_amount := 50.0

func apply_effects(target: Node) -> void:
	if target is Train:
		target.weight += self.weight
		target.transport_amount += transport_amount
