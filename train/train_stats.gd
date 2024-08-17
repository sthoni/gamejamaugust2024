class_name TrainStats extends Resource

@export_group("Train Attributes")
@export var id: String
@export var items: Array[Item]
@export var start_velocity: float = -5.0

@export_group("Train Visuals")
@export var sprite: Texture
