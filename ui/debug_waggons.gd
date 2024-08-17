extends Label

func _ready() -> void:
	@warning_ignore("return_value_discarded")
	Events.waggons_counted.connect(_on_waggons_counted)

func _on_waggons_counted(waggons: int) -> void:
	self.text = "Waggons: " + str(waggons)
