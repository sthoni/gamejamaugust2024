extends Node

# Train Events
signal velocity_changed(velocity: float)
signal accelaration_changed(acc: float)

# Station Events
signal station_status_changed(status: Station.TrainStatus)

# Level Events
signal money_changed(money: int)
