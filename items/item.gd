class_name Item extends Resource

enum Type {TRAIN, STATION}

@export_group("Item Attributes")
@export var id: String
@export var type: Type
@export var price: int
@export var weight: float

@export_group("Item Visuals")
@export var name: String
@export var icon: Texture
@export_multiline var tooltip_text: String

func apply_effects(_target: Node) -> void:
	pass
