class_name Game extends Node

var game_stats: GameStats: set = _set_game_stats

@onready var shop_scene := preload("res://ui/shop.tscn")
@onready var level_scene := preload("res://level/level.tscn")

@export var levels: Array[PackedScene]

var level_ended := false

func _ready() -> void:
	game_stats = load("res://game_stats_start.tres")
	randomize()


func _set_game_stats(value: GameStats) -> void:
	game_stats = value
	game_stats.money = value.start_money
	

func _on_level_end_reached() -> void:
	level_ended = true
	get_tree().paused = true
	game_stats.current_level += 1


func _on_shop_continue_button_pressed() -> void:
	pass


func change_to_shop() -> void:
	get_tree().change_scene_to_packed(shop_scene)


func change_to_level() -> void:
	get_tree().change_scene_to_packed(level_scene)
	get_tree().paused = false
