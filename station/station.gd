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
var status: TrainStatus = TrainStatus.NOT_ARRIVED

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	status_changed()


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
				status_changed()
			TrainStatus.AT_END:
				print("Too far. Ride back!")
				status = TrainStatus.STOPPED_WRONG


func status_changed() -> void:
	Events.emit_signal("station_status_changed", status)


func _on_station_start_body_entered(body: Node2D) -> void:
	if body is Train:
		status = TrainStatus.AT_START
		train_at_station = body
		status_changed()


func _on_station_start_body_exited(body: Node2D) -> void:
	if body is Train:
		status = TrainStatus.AT_STATION
		status_changed()


func _on_station_end_body_entered(body: Node2D) -> void:
	if body is Train:
		status = TrainStatus.AT_END
		status_changed()


func _on_station_end_body_exited(body: Node2D) -> void:
	if body is Train:
		if status == TrainStatus.STOPPED:
			status = TrainStatus.DEPARTED
		else:
			status = TrainStatus.AT_STATION
		train_at_station = null
		status_changed()
