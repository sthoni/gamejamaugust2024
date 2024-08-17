class_name Level extends Node2D

signal money_changed(money: int)

@onready var money := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_station_station_status_changed(status: Station.TrainStatus) -> void:
	print(status)
	if status == Station.TrainStatus.STOPPED:
		money += 100
		emit_signal("money_changed", money)
		get_tree().paused = true
		%Shop.show()


func _on_continue_button_pressed() -> void:
	%Shop.hide()
	get_tree().paused = false
