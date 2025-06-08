class_name Level extends Node2D

@export var level_stats: LevelStats: set = _set_level_stats
@onready var tiles: TileMapLayer = $TileMapLayer

@onready var train: Train = %Train
@onready var path_to_follow: PathFollow2D = $Path2D/PathFollow2D

var level_time := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_level_stats(level_stats)
	GameState.game_stats.last_level_start_money = GameState.game_stats.money

func _process(delta: float) -> void:
	level_time += delta

func _set_level_stats(value: LevelStats) -> void:
	level_stats = value
	if train:
		train.train_stats = level_stats.train_stats
	
func _on_level_end_body_entered(body: Node2D) -> void:
	if body is Train:
		Events.emit_signal("level_end_reached")
		GameState.game_stats.last_level_time = level_time
		GameState.game_stats.last_level_end_money = GameState.game_stats.money
		GameState.change_to_level_end()


func _on_money_timer_timeout() -> void:
	GameState.game_stats.money -= 1
