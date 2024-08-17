extends Node


# Train Events
signal velocity_changed(velocity: float)
signal accelaration_changed(acc: float)
signal waggons_counted(waggons: int)
signal weight_changed(weight: float)

# Station Events
signal station_status_changed(status: Station.TrainStatus)

# Level Events
signal money_changed(money: int)

# Shop Events
signal item_bought(item: Item)
signal item_buy_button_pressed(item: Item)
