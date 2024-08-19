class_name Item extends Resource

enum ItemType {TRAIN, STATION, WAGGON, ENGINE, BRAKES}

@export_group("Item Attributes")
@export var id: String
@export var item_type: ItemType
@export var price: int
@export var weight: float

@export_group("Item Visuals")
@export var name: String
@export var icon: AtlasTexture
@export var sprite: AtlasTexture
@export_multiline var tooltip_text: String

func apply_effects(_target: Node) -> void:
	pass
