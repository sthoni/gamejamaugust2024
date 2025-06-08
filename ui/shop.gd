class_name Shop extends Control

@export var item_pool: ItemPool

@onready var item_display1: ItemDisplay = %ItemDisplay
@onready var item_display2: ItemDisplay = %ItemDisplay2
@onready var items_display_grid: GridContainer = %ItemsDisplayGrid
@onready var money_label: Label = %MoneyPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if item_pool:
		var shop_items := item_pool.get_two_unique_random_items()
		item_display1.item_displayed = shop_items[0]
		item_display2.item_displayed = shop_items[1]
	Events.connect("money_changed", _on_money_changed)
	_on_money_changed(GameState.game_stats.money, GameState.game_stats.money)

func add_item(node: Node) -> void:
	items_display_grid.add_child(node)

func _on_continue_button_pressed() -> void:
	GameState.change_to_level()

func _on_money_changed(money_old: int, money: int) -> void:
	var tween := create_tween()
	tween.tween_method(func(mon: int) -> void: money_label.text = "Money: %s" % mon, money_old, money, 2)
