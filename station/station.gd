class_name Station extends Area2D

@onready var platform: CollisionShape2D = $Platform
@onready var station_start: Area2D = $StationStart
@onready var station_end: Area2D = $StationEnd
@onready var station_label: Label = %StationName
@onready var money_earned_label: Label = %MoneyEarned
@onready var money_earned_sum_label: Label = %MoneyEarnedSum
@onready var money_player: AudioStreamPlayer = $MoneyPlayer

@export var station_stats: StationStats: set = set_station_stats
@onready var train_stats: Resource = GameState.game_stats.train_stats

var has_money: bool = true
var money_earned_sum: int = 0

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
	money_earned_label.hide()
	money_earned_sum_label.hide()

func set_station_stats(value: StationStats) -> void:
	station_stats = value
	if station_stats and station_label:
		station_label.text = station_stats.name
		has_money = true

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
					pay_money()
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


func pay_money() -> void:
	var tween := create_tween()
	var mult_sum := 1.0
	money_earned_sum_label.text = "%s $" % money_earned_sum
	money_earned_sum_label.show()
	var old_money_earned_sum := money_earned_sum
	money_earned_sum += station_stats.reward
	tween.tween_callback(func() -> void:
				money_earned_label.text = "Reward: %s $" % station_stats.reward
				money_earned_label.show()
				money_player.play()
				)
	tween.tween_property(money_earned_label, "position", Vector2(20.0, -100.0), 1)
	tween.tween_method(func(mon: int) -> void: money_earned_sum_label.text = "%s $" % mon, old_money_earned_sum, money_earned_sum, 0.5)
	tween.tween_callback(func() -> void:
				money_earned_label.hide()
				money_earned_label.position = Vector2(20.0, -80.0)
				)
	for item in train_stats.items:
		if item.get("transport_amount"):
			mult_sum *= item.transport_mult
			money_earned_sum += item.transport_amount
			tween.tween_callback(func() -> void:
				money_earned_label.text = "%s: %s $" % [item.name[0], item.transport_amount]
				money_earned_label.show()
				money_player.play()
				)
			tween.tween_method(func(mon: int) -> void: money_earned_sum_label.text = "%s $" % mon, old_money_earned_sum, money_earned_sum, 0.5)
			tween.tween_property(money_earned_label, "position", Vector2(20.0, -100.0), 1)
			tween.tween_callback(func() -> void:
				money_earned_label.hide()
				money_earned_label.position = Vector2(20.0, -80.0)
				)
			old_money_earned_sum = money_earned_sum
	money_earned_sum *= mult_sum
	tween.tween_callback(func() -> void:
		money_earned_label.text = "Multi: x%s" % mult_sum
		money_earned_label.show()
		money_player.play()
	)
	tween.tween_method(func(mon: int) -> void: money_earned_sum_label.text = "%s $" % mon, old_money_earned_sum, money_earned_sum, 0.5)
	tween.tween_property(money_earned_label, "position", Vector2(20.0, -100.0), 1)
	tween.tween_callback(func() -> void: money_earned_label.hide())

	has_money = false
	GameState.game_stats.money += money_earned_sum
