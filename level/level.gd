class_name Level extends Node2D

@export var level_stats: LevelStats : set = set_level_stats

@onready var train: Train = $Train
@onready var station: Station = $Station
@onready var shop: Shop = $Shop

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_level_stats(level_stats)
	@warning_ignore("return_value_discarded")
	Events.station_status_changed.connect(_on_station_station_status_changed)

# ACHTUNG: Die Position des Trains im Level wird hier auch gesetzt
func set_level_stats(value: LevelStats):
	level_stats = value
	if train:
		train.train_stats = level_stats.train_stats
		train.position.y = 650
		station.station_stats = level_stats.station_stats
		var shop_items: Array[Item] = level_stats.item_pool.get_two_unique_random_items()
		shop.item_display1.item_displayed = shop_items[0]
		shop.item_display2.item_displayed = shop_items[1]


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DEBUG_train_teleport"):
		train.position.y = 200


func _on_station_station_status_changed(status: Station.TrainStatus) -> void:
	if status == Station.TrainStatus.STOPPED:
		Events.emit_signal("station_freight_sold", train.transport_amount)
		get_tree().paused = true
		shop.show()


func _on_level_end_body_entered(body: Node2D) -> void:
	if body is Train:
		Events.emit_signal("level_end_reached")
