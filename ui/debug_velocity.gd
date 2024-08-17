extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.velocity_changed.connect(_on_train_velocity_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_train_velocity_changed(velocity: float) -> void:
	self.text = "Velocity: " + str(velocity)
