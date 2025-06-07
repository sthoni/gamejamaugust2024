extends Control

class_name Menu

@onready var start_button: Button = %StartButton
@onready var quit_button: Button = %QuitButton

func _ready() -> void:
    start_button.pressed.connect(func() -> void:
        get_tree().paused = false
        start_button.text = "Continue"
        hide()
    )

    quit_button.pressed.connect(func() -> void:
        get_tree().quit()
        )

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("exit_to_menu"):
        get_tree().quit()
    
    if event.is_action_pressed("shop"):
        get_tree().paused = false
        start_button.text = "Continue"
        hide()