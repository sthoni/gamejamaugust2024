class_name LevelStats extends Resource

@export_group("Level Attributes")
@export var station_stats: StationStats
@export var train_stats: TrainStats
@export var item_pool: ItemPool
@export var mission: Mission

@export_group("Level Visuals")
@export var background_texture: TileSet

# Braucht man das überhaupt?
func create_instance(difficulty: int = 1) -> LevelStats:
	var instance: LevelStats = self.duplicate()
	instance.station_stats = station_stats.create_instance(difficulty)
	return instance
