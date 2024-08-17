extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.money_changed.connect(_on_level_money_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_level_money_changed(money: int) -> void:
	self.text = "Money: " + str(money)
