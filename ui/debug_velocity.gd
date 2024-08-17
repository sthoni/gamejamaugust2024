extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	@warning_ignore("return_value_discarded")
	Events.velocity_changed.connect(_on_train_velocity_changed)


func _on_train_velocity_changed(velocity: float) -> void:
	self.text = "Velocity: %5.2f" % (velocity * -1.0)
