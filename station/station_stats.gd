class_name StationStats extends Resource

@export_group("Station Attributes")
@export var station_name: String
@export var distance: int
@export var platform_length: float
@export var sprite: Texture

@export_group("Mission Stats")
@export var target_time: float
@export var time_limit: float
@export var penalty_per_second_late: int
@export var miss_penalty: int


func create_instance(difficulty: int = 1) -> StationStats:
	var instance: StationStats = self.duplicate()
	instance.distance = 200 + randi_range(-80, 80)
	instance.platform_length = 50 * 2 - clampi(difficulty * 3, 1, 50)
	return instance
