class_name StationStats extends Resource

@export_group("Station Attributes")
@export var y_position: int
@export var platform_length: float
@export var sprite: Texture


func create_instance(difficulty: float = 1.0) -> StationStats:
	var instance: StationStats = self.duplicate()
	instance.y_position = 140 + randi_range(-20, 20)
	instance.platform_length = 50 * (difficulty + 1.0)
	return instance
