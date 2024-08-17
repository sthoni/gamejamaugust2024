extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.accelaration_changed.connect(_on_train_accelaration_changed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_train_accelaration_changed(acc: float) -> void:
	self.text = "Acceleration: %5.2f" % (acc * -1.0)
