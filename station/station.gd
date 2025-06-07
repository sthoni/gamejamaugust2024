class_name Station extends Area2D

signal train_correctly_stopped(station_name: String)
signal station_missed(station_name: String)

@export var station_name: String
@export var station_stats: StationStats : set = set_station_stats

@onready var platform: CollisionShape2D = $Platform
@onready var station_start: Area2D = $StationStart
@onready var station_end: Area2D = $StationEnd

var has_money: bool = true

enum TrainStatus {
	STOPPED,
	STOPPED_WRONG,
	AT_START,
	AT_STATION,
	AT_END,
	NOT_ARRIVED,
	DEPARTED
}

enum StationType {
	LOADING,				#eaxmple: Coal Mine
	UNLOADING,			#example: Coal-fired power plant
	SHOP	
}

var train_at_station: Train = null
var status: TrainStatus : set = set_status

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	status = TrainStatus.NOT_ARRIVED
	set_station_stats(station_stats)

func set_station_stats(value: StationStats) -> void:
	station_stats = value
	has_money = true
	self.global_position.y = station_stats.distance
	if platform:
		@warning_ignore("unsafe_property_access")
		platform.shape.size.y = station_stats.platform_length
		station_start.position.y = station_stats.platform_length / 2
		station_end.position.y = -station_stats.platform_length / 2

func set_status(value: TrainStatus) -> void:
	status = value
	@warning_ignore("return_value_discarded")
	Events.emit_signal("station_status_changed", status)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if train_at_station is Train && (train_at_station as Train).velocity.y == 0:
		match status:
			TrainStatus.AT_START:
				print("Too soon.")
				status = TrainStatus.STOPPED_WRONG
			TrainStatus.AT_STATION:
				print("Perfect!")
				status = TrainStatus.STOPPED
				if has_money:
					Events.emit_signal("station_freight_sold", train_at_station.transport_amount)
					has_money = false
				train_correctly_stopped.emit(station_name)
			TrainStatus.AT_END:
				print("Too far. Ride back!")
				status = TrainStatus.STOPPED_WRONG


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shop"):
		if status == TrainStatus.STOPPED:
			Events.emit_signal("shop_key_pressed")


func status_changed() -> void:
	@warning_ignore("return_value_discarded")
	Events.emit_signal("station_status_changed", status)


func _on_station_start_body_entered(body: Node2D) -> void:
	if body is Train:
		status = TrainStatus.AT_START
		train_at_station = body
		Events.emit_signal("train_at_start")


func _on_station_start_body_exited(body: Node2D) -> void:
	if body is Train:
		var train_body: Train = body
		if train_body.velocity.y < 0:
			status = TrainStatus.AT_STATION
		else:
			status = TrainStatus.NOT_ARRIVED
		Events.emit_signal("train_exited")


func _on_station_end_body_entered(body: Node2D) -> void:
	if body is Train:
		var train_body: Train = body
		status = TrainStatus.AT_END
		if train_body.velocity.y > 0:
			train_at_station = train_body


func _on_station_end_body_exited(body: Node2D) -> void:
	if body is Train:
		var train_body: Train = body
		if train_body.velocity.y < 0:
			status = TrainStatus.DEPARTED
			train_at_station = null
		else:
			status = TrainStatus.AT_STATION


func _on_body_entered(body: Node2D) -> void:
	if body is Train && status == TrainStatus.NOT_ARRIVED:
		status = TrainStatus.AT_STATION

func _on_body_exited(body: Node2D) -> void:
	if body is Train:
		var train_body: Train = body
		# Check if the train exited the main station area without stopping correctly
		if (status == TrainStatus.NOT_ARRIVED or status == TrainStatus.AT_STATION) and abs(train_body.velocity.y) > 10: # Threshold velocity
			print("Train missed station: ", station_name)
			station_missed.emit(station_name)
