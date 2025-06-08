class_name Shop extends Control

@onready var item_display1: ItemDisplay = %ItemDisplay
@onready var item_display2: ItemDisplay = %ItemDisplay2
@onready var items_display_grid: GridContainer = %ItemsDisplayGrid
@onready var money_label: Label = %MoneyPlayer

signal continue_button_pressed()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.connect("money_changed", _on_money_changed)

func add_item(node: Node) -> void:
	items_display_grid.add_child(node)

func _on_continue_button_pressed() -> void:
	continue_button_pressed.emit()

func _on_money_changed(money_old: int, money: int) -> void:
	var tween := create_tween()
	tween.tween_method(func(mon: int) -> void: money_label.text = "Money: %s" % mon, money_old, money, 2)
	item_display1.check_for_enough_money(money)
	item_display2.check_for_enough_money(money)
