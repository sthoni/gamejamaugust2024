extends Control

class_name GameEnd

@onready var end_text: RichTextLabel = %EndText
@onready var start_button: Button = %StartButton
@onready var quit_button: Button = %QuitButton

func _ready() -> void:
    start_button.pressed.connect(func() -> void:
        GameState.game_start()
    )
    quit_button.pressed.connect(func() -> void:
        get_tree().quit()
        )
    if GameState.game_stats.money > 0:
        end_text.text = "You have successefully reached the end of the game. Congratiulations and thank you for playing!\nYou earned %s money." % (GameState.game_stats.money - GameState.game_stats.start_money)
    else:
        end_text.text = "You have no money left. Try again!\n"
    end_text.text += "You played for %.2f seconds." % GameState.game_stats.level_time_sum

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("exit_to_menu"):
        get_tree().quit()
    
    if event.is_action_pressed("shop"):
        GameState.game_start()