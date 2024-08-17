extends Control

@export var item_one: Item
@export var item_two: Item

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%ItemDisplay.set_item(item_one)
	%ItemDisplay2.set_item(item_two)
	Events.connect("money_changed", _on_money_changed)

func add_item(node: Node) -> void:
	%ItemsDisplayGrid.add_child(node)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_continue_button_pressed() -> void:
	%Shop.hide()
	get_tree().paused = false


func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_money_changed(money) -> void:
	%MoneyPlayer.text = "Money: %s" % money
