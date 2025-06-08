class_name GameStats extends Resource

@export_group("Game Attributes")
@export var train_stats: TrainStats
@export var start_money: int

var current_level: int = 1
var money: int:
	get:
		return money
	set(value):
		var money_old := money
		money = value
		Events.emit_signal("money_changed", money_old, money)
