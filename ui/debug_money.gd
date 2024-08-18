extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	@warning_ignore("return_value_discarded")
	Events.money_changed.connect(_on_level_money_changed)


func _on_level_money_changed(money: int) -> void:
	self.text = "Money: " + str(money)
