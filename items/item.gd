class_name Item extends Resource

enum ItemType {TRAIN, STATION, WAGGON}

@export_group("Item Attributes")
@export var id: String
@export var item_type: ItemType
@export var price: int
@export var weight: float

@export_group("Item Visuals")
@export var name: String
@export var icon: Texture
@export_multiline var tooltip_text: String

func apply_effects(_target: Node) -> void:
	pass
