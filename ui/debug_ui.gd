class_name DebugUi extends Control

@onready var money_label: Label = %MoneyLabel
@onready var velocity_label: Label = %VelocityLabel
@onready var acc_label: Label = %AccLabel
@onready var station_label: Label = %StationLabel
@onready var label_container: VBoxContainer = %LabelContainer

var train_stats_labels_name: Array[String] = ["waggon_amount", "weight", "transport_amount", "acc_power", "brake_power"]
var train_stats_labels_nodes: Dictionary[String, Label]

func _ready() -> void:
    Events.money_changed.connect(func(_old_money: int, money: int) -> void: money_label.text = "PMoney: " + str(money))
    Events.station_status_changed.connect(_on_station_status_changed)
    Events.train_stats_changed.connect(_on_train_stats_changed)

    Events.velocity_changed.connect(func(vel: float) -> void: velocity_label.text = "TVel: " + str(vel))
    Events.accelaration_changed.connect(func(acc: float) -> void: acc_label.text = "TAcc: " + str(acc))

    for label: String in train_stats_labels_name:
        train_stats_labels_nodes[label] = Label.new()
        label_container.add_child(train_stats_labels_nodes[label])

func _on_train_stats_changed(stats: TrainStats) -> void:
    for label in train_stats_labels_name:
        train_stats_labels_nodes[label].text = label + ": " + str(stats[label])

func _on_station_status_changed(status: Station.TrainStatus) -> void:
    match status:
        Station.TrainStatus.AT_START:
            station_label.text = "Train at Start"
        Station.TrainStatus.AT_STATION:
            station_label.text = "Train at Station"
        Station.TrainStatus.AT_END:
            station_label.text = "Train at End"
        Station.TrainStatus.STOPPED:
            station_label.text = "Train stopped"
        Station.TrainStatus.DEPARTED:
            station_label.text = "Train departed"
        Station.TrainStatus.NOT_ARRIVED:
            station_label.text = "Train not arrived"


func _input(event: InputEvent) -> void:
    if event.is_action_pressed("DebugMenu"):
        self.visible = !self.visible
