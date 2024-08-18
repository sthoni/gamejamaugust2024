class_name StationStats extends Resource

@export_group("Station Attributes")
@export var y_position: int
@export var platform_length: float
@export var sprite: Texture


func create_instance(difficulty: int = 1) -> StationStats:
	var instance: StationStats = self.duplicate()
	instance.y_position = 200 + randi_range(-80, 80)
	instance.platform_length = 50 * 2 - clampi(difficulty * 3, 1, 50)
	return instance
