class_name LevelStats extends Resource

@export_group("Level Attributes")
@export var train_stats: TrainStats
@export var item_pool: ItemPool

@export_group("Mission Attributes")
@export var mission_reward := 500
@export var mission_penalty := 300

@export_group("Level Visuals")
@export var background_texture: TileSet
