class_name StationStats extends Resource

@export_group("Station Attributes")
@export var name: String
@export var platform_length: float
@export var sprite: Texture

@export_group("Mission Stats")
@export var target_time: float
@export var time_limit: float
@export var penalty_per_second_late: int
@export var miss_penalty: int
