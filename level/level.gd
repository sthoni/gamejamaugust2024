class_name Level extends Node2D

@export var level_stats: LevelStats : set = set_level_stats
@export var game_stats: GameStats
@onready var tiles: TileMapLayer = $TileMapLayer
@onready var mission_manager: MissionManager = $MissionManager # Assuming the node is named MissionManager

@onready var train: Train = %Train
@onready var path_to_follow: PathFollow2D = $Path2D/PathFollow2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_level_stats(level_stats)
	if mission_manager:
		mission_manager.mission_completed.connect(_on_mission_completed)
		mission_manager.mission_failed.connect(_on_mission_failed)
		mission_manager.apply_penalty.connect(game_stats.apply_money_penalty) # Connect penalty signal
		# Connect station signals to mission manager
		for child in get_children():
			if child is Station:
				var station_child: Station = child
				mission_manager.mission.append(station_child.station_stats)
				station_child.train_correctly_stopped.connect(mission_manager._on_station_correctly_stopped)
				station_child.station_missed.connect(mission_manager._on_station_missed)
		mission_manager.start_mission() # Start the mission when the level is ready

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
	# TODO: Implement level completion logic (e.g., show results screen, load next level)

func _on_mission_failed() -> void:
	print("Level received mission failed signal.")
	# TODO: Implement level failed logic (e.g., show game over screen, restart level)
