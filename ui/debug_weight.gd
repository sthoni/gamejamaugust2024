extends Label

func _ready() -> void:
	Events.weight_changed.connect(_on_weights_changed)

func _on_weights_changed(weight: float) -> void:
	self.text = "Weight: " + str(weight)
