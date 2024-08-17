extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.station_status_changed.connect(_on_station_station_status_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_station_station_status_changed(status: Station.TrainStatus) -> void:
	match status:
		Station.TrainStatus.AT_START:
			self.text = "Train at Start"
		Station.TrainStatus.AT_STATION:
			self.text = "Train at Station"
		Station.TrainStatus.AT_END:
			self.text = "Train at End"
		Station.TrainStatus.STOPPED:
			self.text = "Train stopped"
		Station.TrainStatus.DEPARTED:
			self.text = "Train departed"
		Station.TrainStatus.NOT_ARRIVED:
			self.text = "Train not arrived"
