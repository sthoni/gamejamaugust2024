class_name Shop extends Control

@onready var item_display1: ItemDisplay = %ItemDisplay
@onready var item_display2: ItemDisplay = %ItemDisplay2
@onready var items_display_grid: GridContainer = %ItemsDisplayGrid
@onready var money_label: Label = %MoneyPlayer
@onready var game_stats: GameStats

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	@warning_ignore("return_value_discarded")
	Events.connect("money_changed", _on_money_changed)

func add_item(node: Node) -> void:
	items_display_grid.add_child(node)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_continue_button_pressed() -> void:
	self.hide()
	get_tree().paused = false


func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_money_changed(money: int) -> void:
	money_label.text = "Money: %s" % money
