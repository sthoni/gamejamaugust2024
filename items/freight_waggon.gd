class_name FreightWaggon extends Item

@export var transport_amount := 50.0

func apply_effects(target: Node) -> void:
	if target is Train:
		target.waggon_amount += 1
		target.train_shape.scale.y = target.waggon_amount
		target.train_shape.position.y = (target.waggon_amount * target.train_shape.shape.size.y - 48) / 2
		target.weight += self.weight
		target.transport_amount += transport_amount
