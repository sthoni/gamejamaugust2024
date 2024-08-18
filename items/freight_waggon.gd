class_name FreightWaggon extends Item

@export var transport_amount := 50.0
var waggon = preload("res://train/waggon.tscn")

func apply_effects(target: Node) -> void:
	if target is Train:
		target.transport_amount += transport_amount
