extends Node


# Train Events
@warning_ignore("unused_signal")
signal velocity_changed(velocity: float)
@warning_ignore("unused_signal")
signal accelaration_changed(acc: float)
@warning_ignore("unused_signal")
signal waggons_counted(waggons: int)
@warning_ignore("unused_signal")
signal weight_changed(weight: float)

# Station Events
@warning_ignore("unused_signal")
signal station_status_changed(status: Station.TrainStatus)

# Level Events
@warning_ignore("unused_signal")
signal money_changed(money: int)

# Shop Events
@warning_ignore("unused_signal")
signal item_bought(item: Item)
@warning_ignore("unused_signal")
signal item_buy_button_pressed(item: Item)
