class_name GameStats extends Resource

@export_group("Game Attributes")
@export var train_stats: TrainStats
@export var start_money: int

var money: int : set = set_money
var current_level: int = 1

func set_money(value: int) -> void:
	money = value
	Events.emit_signal("money_changed", money)

func apply_money_penalty(amount: int) -> void:
	money -= amount
	Events.emit_signal("money_changed", money)
