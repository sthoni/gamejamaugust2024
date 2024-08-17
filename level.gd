class_name Level extends Node2D

signal money_changed(money: int)

@onready var money: int: set = set_money
@onready var train: Train = $Train

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	money = 0
	Events.emit_signal("money_changed", money)
	Events.station_status_changed.connect(_on_station_station_status_changed)
	Events.item_buy_button_pressed.connect(_on_item_buy_button_pressed)


func set_money(value: int) -> void:
	money = value
	Events.emit_signal("money_changed", money)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DEBUG_train_teleport"):
		train.position.y = 200

func _on_station_station_status_changed(status: Station.TrainStatus) -> void:
	if status == Station.TrainStatus.STOPPED:
		money += train.transport_amount
		get_tree().paused = true
		%Shop.show()

func _on_item_buy_button_pressed(item: Item) -> void:
	if item.price <= money:
		money -= item.price
		Events.emit_signal("item_bought", item)
