class_name Station extends Area2D

enum TrainStatus {
	STOPPED,
	STOPPED_WRONG,
	AT_START,
	AT_STATION,
	AT_END,
	NOT_ARRIVED,
	DEPARTED
}

var train_at_station: Train = null
var status: TrainStatus : set = set_status

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	status = TrainStatus.NOT_ARRIVED

func set_status(value: TrainStatus) -> void:
	status = value
	Events.emit_signal("station_status_changed", status)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if train_at_station && train_at_station.velocity.y == 0:
		match status:
			TrainStatus.AT_START:
				print("Too soon.")
				status = TrainStatus.STOPPED_WRONG
			TrainStatus.AT_STATION:
				print("Perfect!")
				status = TrainStatus.STOPPED
			TrainStatus.AT_END:
				print("Too far. Ride back!")
				status = TrainStatus.STOPPED_WRONG


func status_changed() -> void:
	Events.emit_signal("station_status_changed", status)


func _on_station_start_body_entered(body: Node2D) -> void:
	if body is Train:
		status = TrainStatus.AT_START
		train_at_station = body


func _on_station_start_body_exited(body: Node2D) -> void:
	if body is Train:
		if body.velocity.y < 0:
			status = TrainStatus.AT_STATION
		else:
			status = TrainStatus.NOT_ARRIVED


func _on_station_end_body_entered(body: Node2D) -> void:
	if body is Train:
		status = TrainStatus.AT_END


func _on_station_end_body_exited(body: Node2D) -> void:
	if body is Train:
		if body.velocity.y < 0:
			status = TrainStatus.DEPARTED
			train_at_station = null
		else:
			status = TrainStatus.AT_STATION
