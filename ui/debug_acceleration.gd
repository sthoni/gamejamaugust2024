extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	@warning_ignore("return_value_discarded")
	Events.accelaration_changed.connect(_on_train_accelaration_changed)


func _on_train_accelaration_changed(acc: float) -> void:
	self.text = "Acceleration: %5.2f" % (acc * -1.0)
