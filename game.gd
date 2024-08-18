class_name Game extends Node

@export var game_stats: GameStats : set = set_game_stats

@onready var level: Level = $Level
@onready var level_stats: LevelStats = preload("res://level/level_start.tres")

func _ready() -> void:
	game_stats.money = game_stats.start_money
	level.level_stats = create_level_stats()
	@warning_ignore("return_value_discarded")
	Events.item_buy_button_pressed.connect(_on_item_buy_button_pressed)
	@warning_ignore("return_value_discarded")
	Events.station_freight_sold.connect(_on_station_freight_sold)
	@warning_ignore("return_value_discarded")
	Events.level_end_reached.connect(_on_level_end_reached)


func set_game_stats(value: GameStats):
	game_stats = value


func _on_item_buy_button_pressed(item: Item) -> void:
	if item.price <= game_stats.money:
		game_stats.money -= item.price
		@warning_ignore("return_value_discarded")
		Events.emit_signal("item_bought", item)


func _on_station_freight_sold(count: int) -> void:
	game_stats.money += count


func create_level_stats() -> LevelStats:
	var new_level_stats: LevelStats = level_stats.create_instance()
	return new_level_stats


func _on_level_end_reached() -> void:
	level.level_stats = level_stats.create_instance()
