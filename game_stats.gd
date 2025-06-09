class_name GameStats extends Resource

@export_group("Game Attributes")
@export var train_stats: TrainStats
@export var start_money: int

var last_level: int = 0
var last_level_time: float = 0.0
var last_level_start_money: int = 0
var last_level_end_money: int = 0

var level_time_sum: float = 0

var money: int:
	get:
		return money
	set(value):
		var money_old := money
		money = value
		Events.emit_signal("money_changed", money_old, money)


func reset_stats() -> void:
	last_level = 0
	last_level_time = 0.0
	last_level_start_money = 0
	last_level_end_money = 0
	level_time_sum = 0
	money = start_money
