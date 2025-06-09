class_name Station extends Area2D

@onready var platform: CollisionShape2D = $Platform
@onready var station_start: Area2D = $StationStart
@onready var station_end: Area2D = $StationEnd
@onready var station_label: Label = %StationName
@onready var money_earned_label: Label = %MoneyEarned
@onready var money_player: AudioStreamPlayer = $MoneyPlayer

@export var station_stats: StationStats: set = set_station_stats

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
	LOADING, # eaxmple: Coal Mine
	UNLOADING, # example: Coal-fired power plant
	SHOP
}

var train_at_station: Train = null
var status: TrainStatus: set = set_status

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	status = TrainStatus.NOT_ARRIVED
	set_station_stats(station_stats)

func set_station_stats(value: StationStats) -> void:
	station_stats = value
	if station_stats and station_label:
		station_label.text = station_stats.name
		has_money = true
		if platform:
			platform.shape.size.y = station_stats.platform_length
			station_start.position.y = station_stats.platform_length / 2 + 8
			station_end.position.y = - station_stats.platform_length / 2 - 8

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
					var tween := create_tween()
					for item in train_at_station.train_stats.items:
						if item.get("transport_amount"):
							tween.tween_callback(func() -> void:
								money_earned_label.text = "%s $" % item.transport_amount
								GameState.game_stats.money += item.transport_amount
								money_earned_label.show()
								money_player.play()
								)
							tween.tween_property(money_earned_label, "position", Vector2(20.0, -80.0), 1)
							tween.tween_callback(func() -> void:
								money_earned_label.hide()
								money_earned_label.position = Vector2(10.0, -60.0)
								)
					has_money = false
			TrainStatus.AT_END:
				print("Too far. Ride back!")
				status = TrainStatus.STOPPED_WRONG


func status_changed() -> void:
	@warning_ignore("return_value_discarded")
	Events.emit_signal("station_status_changed", status)


func _on_station_start_body_entered(body: Node2D) -> void:
	if body is Train:
		status = TrainStatus.AT_START
		train_at_station = body
		print("Train at Start")
		Events.emit_signal("train_at_start")


func _on_station_start_body_exited(body: Node2D) -> void:
	if body is Train:
		var train_body: Train = body
		if train_body.velocity.y > 0:
			status = TrainStatus.AT_STATION
		else:
			status = TrainStatus.NOT_ARRIVED
		print("Train at End")
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
		if train_body.velocity.y > 0:
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
		if (status == TrainStatus.NOT_ARRIVED or status == TrainStatus.AT_END) and abs(train_body.velocity.y) > 50: # Threshold velocity
			print("Train missed station: ", station_stats.name)
			var tween := create_tween()
			tween.tween_callback(func() -> void:
								money_earned_label.text = "-30 $"
								GameState.game_stats.money -= 30
								money_earned_label.show()
								money_player.play()
								)
			tween.tween_property(money_earned_label, "position", Vector2(20.0, -80.0), 1)
			tween.tween_callback(func() -> void:
								money_earned_label.hide()
								money_earned_label.position = Vector2(10.0, -60.0)
			)
