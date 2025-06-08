class_name LevelEnd extends PanelContainer

@onready var label_level: Label = %LabelLevel
@onready var label_level_time: Label = %LabelLevelTime
@onready var label_level_money: Label = %LabelLevelMoney
@onready var button_shop: Button = %ButtonShop
@onready var button_next_level: Button = %ButtonNextLevel

func _ready() -> void:
    button_shop.pressed.connect(_on_button_shop_pressed)
    button_next_level.pressed.connect(_on_button_next_level_pressed)
    label_level.text = "That was Level " + str(GameState.game_stats.last_level)
    label_level_time.text = "You have reached the end in %.2f seconds." % GameState.game_stats.last_level_time
    label_level_money.text = "You have earned %s $." % (GameState.game_stats.last_level_end_money - GameState.game_stats.last_level_start_money)
    GameState.game_stats.last_level += 1


func _input(event: InputEvent) -> void:
    if event.is_action_pressed("shop"):
        _on_button_shop_pressed()

func _on_button_shop_pressed() -> void:
    GameState.change_to_shop()

func _on_button_next_level_pressed() -> void:
    GameState.change_to_level()