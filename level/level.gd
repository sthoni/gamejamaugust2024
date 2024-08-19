class_name Level extends Node2D

@export var level_stats: LevelStats : set = set_level_stats

@onready var train: Train = $Train
@onready var station: Station = $Station
@onready var hints: Control = %Hints
@onready var tiles: TileMapLayer = $TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hints.visible = false
	set_level_stats(level_stats)
	@warning_ignore("return_value_discarded")
	Events.station_status_changed.connect(_on_station_status_changed)

# ACHTUNG: Die Position des Trains im Level wird hier auch gesetzt
func set_level_stats(value: LevelStats):
	level_stats = value
	if train:
		train.train_stats = level_stats.train_stats
		train.position.y = 670
		station.station_stats = level_stats.station_stats
		tiles.tile_set = level_stats.background_texture


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DEBUG_train_teleport"):
		train.position.y = 200

func _on_station_status_changed(value: Station.TrainStatus) -> void:
	if value == Station.TrainStatus.STOPPED:
		hints.visible = true
	else:
		hints.visible = false
	
func _on_level_end_body_entered(body: Node2D) -> void:
	if body is Train:
		Events.emit_signal("level_end_reached")
