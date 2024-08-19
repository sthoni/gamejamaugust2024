class_name Game extends Node

@export var game_stats: GameStats : set = set_game_stats

@onready var level: Level = $Level
@onready var shop: Shop = $Shop
@onready var label_level: Label = %LabelLevel
@onready var panel_container: PanelContainer = $PanelContainer
@onready var level_stats: LevelStats = preload("res://level/level_start.tres")

func _ready() -> void:
	game_stats.money = game_stats.start_money
	var shop_items: Array[Item] = level_stats.item_pool.get_two_unique_random_items()
	shop.item_display1.item_displayed = shop_items[0]
	shop.item_display2.item_displayed = shop_items[1]
	level.level_stats = level_stats.create_instance()
	@warning_ignore("return_value_discarded")
	Events.item_buy_button_pressed.connect(_on_item_buy_button_pressed)
	@warning_ignore("return_value_discarded")
	Events.station_freight_sold.connect(_on_station_freight_sold)
	@warning_ignore("return_value_discarded")
	Events.level_end_reached.connect(_on_level_end_reached)
	@warning_ignore("return_value_discarded")
	Events.shop_key_pressed.connect(_on_shop_key_pressed)


func set_game_stats(value: GameStats):
	game_stats = value


func _on_item_buy_button_pressed(item: Item) -> void:
	if item.price <= game_stats.money:
		game_stats.money -= item.price
		@warning_ignore("return_value_discarded")
		Events.emit_signal("item_bought", item)


func _on_station_freight_sold(count: int) -> void:
	game_stats.money += count


func _on_level_end_reached() -> void:
	game_stats.current_level += 1
	panel_container.position = Vector2(0.0, 640.0)
	var tween = get_tree().create_tween()
	tween.tween_property(panel_container, "position", Vector2(0.0,0.0), 1)
	label_level.text = "Station %s" % game_stats.current_level
	tween.tween_property(label_level, "visible_characters", 11, 1)
	tween.tween_callback(create_new_level)
	tween.tween_property(label_level, "visible_characters", 0, 0.5)
	tween.tween_property(panel_container, "position", Vector2(0.0,-640.0), 1)


func create_new_level() -> void:
	level.level_stats = level_stats.create_instance(game_stats.current_level)
	var shop_items: Array[Item] = level_stats.item_pool.get_two_unique_random_items()
	shop.item_display1.item_displayed = shop_items[0]
	shop.item_display2.item_displayed = shop_items[1]


func _on_shop_key_pressed() -> void:
	shop.show()
	get_tree().paused = true
