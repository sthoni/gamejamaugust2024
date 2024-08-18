extends Control

@onready var needle : = $GaugeTexture/Needle

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.velocity_changed.connect(_on_train_velocity_changed)


func _on_train_velocity_changed(velocity: float) -> void:
	if abs(velocity) < 120:
		needle.rotation = abs(velocity)/120*PI*3/2
	else:
		needle.rotation = PI*3/2
