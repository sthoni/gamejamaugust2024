class_name FreightWaggon extends Item

func apply_effects(target: Node) -> void:
	if target is Train:
		target.waggon_amount += 1
