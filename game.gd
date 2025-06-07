class_name Game extends Node

@export var game_stats: GameStats : set = _set_game_stats

@onready var level: Level = %Level
@onready var shop: Shop = $Shop
@onready var menu: Menu = $Menu
@onready var label_level: Label = %LabelLevel
@onready var button: Button = %Button
@onready var panel_container: PanelContainer = $PanelContainer
@onready var level_start_stats: LevelStats = preload("res://level/level_start.tres")
@onready var money_player: AudioStreamPlayer = $MoneyPlayer

var level_ended := false

func _ready() -> void:
	randomize()
	game_stats.money = game_stats.start_money
	var shop_items: Array[Item] = level_start_stats.item_pool.get_two_unique_random_items()
	shop.item_display1.item_displayed = shop_items[0]
	shop.item_display2.item_displayed = shop_items[1]
	level.level_stats = level_start_stats


	Events.item_buy_button_pressed.connect(_on_item_buy_button_pressed)
	Events.station_freight_sold.connect(_on_station_freight_sold)
	Events.level_end_reached.connect(_on_level_end_reached)
	Events.shop_key_pressed.connect(_on_shop_key_pressed)
	button.pressed.connect(_create_new_level)

	get_tree().paused = true


func _set_game_stats(value: GameStats) -> void:
	game_stats = value


func _on_item_buy_button_pressed(item: Item) -> void:
	if item.price <= game_stats.money:
		game_stats.money -= item.price
		Events.emit_signal("item_bought", item)

	
func _on_station_freight_sold(count: int) -> void:
	game_stats.money += count
	

func _on_level_end_reached() -> void:
	level_ended = true
	game_stats.current_level += 1
	panel_container.position = Vector2(0.0, 640.0)
	var tween := create_tween()
	tween.tween_property(panel_container, "position", Vector2(0.0,0.0), 0.5)
	label_level.text = "You are arriving at Station %s" % game_stats.current_level
	label_level.visible_ratio = 0
	tween.tween_property(label_level, "visible_ratio", 1.0, 1)


func _create_new_level() -> void:
	var tween := create_tween()
	level.level_stats = level_start_stats
	var shop_items: Array[Item] = level_start_stats.item_pool.get_two_unique_random_items()
	shop.item_display1.item_displayed = shop_items[0]
	shop.item_display2.item_displayed = shop_items[1]
	tween.tween_property(panel_container, "position", Vector2(0.0,-640.0), 0.5)
	level_ended = false


func _input(event: InputEvent) -> void:
	if level_ended:
		if event.is_action_pressed("shop"):
			_create_new_level()
	if event.is_action_pressed("exit_to_menu"):
		menu.show()
		get_tree().paused = true
		
	# Input-Router-Funktion, zur Event-Weiterleitung in SubViewport:
	var world := $SubViewport/Level
	for child in world.get_children():
		if child.has_method("_input"):
			child._input(event)

func _on_shop_key_pressed() -> void:
	shop.show()
	get_tree().paused = true
