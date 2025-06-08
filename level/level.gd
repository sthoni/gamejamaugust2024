class_name Level extends Node2D

@export var level_stats: LevelStats : set = set_level_stats
@export var game_stats: GameStats
@onready var tiles: TileMapLayer = $TileMapLayer

@onready var train: Train = %Train
@onready var path_to_follow: PathFollow2D = $Path2D/PathFollow2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_level_stats(level_stats)

# ACHTUNG: Die Position des Trains im Level wird hier auch gesetzt
func set_level_stats(value: LevelStats) -> void:
	level_stats = value
	if train:
		train.train_stats = level_stats.train_stats
		path_to_follow.progress = 0.0


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DEBUG_train_teleport"):
		train.position.y = 200
	
func _on_level_end_body_entered(body: Node2D) -> void:
	if body is Train:
		Events.emit_signal("level_end_reached")

func _on_mission_completed() -> void:
	print("Level received mission completed signal.")
	game_stats.money += 500

func _on_mission_failed() -> void:
	print("Level received mission failed signal.")
	game_stats.money -= 300
