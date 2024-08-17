class_name Level extends Node2D

signal money_changed(money: int)

@onready var money := 0
@onready var train: Train = $Train

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.emit_signal("money_changed", money)
	Events.station_status_changed.connect(_on_station_station_status_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DEBUG_train_teleport"):
		train.position.y -= 420

func _on_station_station_status_changed(status: Station.TrainStatus) -> void:
	if status == Station.TrainStatus.STOPPED:
		money += train.transport_amount
		Events.emit_signal("money_changed", money)
		get_tree().paused = true
		%Shop.show()
