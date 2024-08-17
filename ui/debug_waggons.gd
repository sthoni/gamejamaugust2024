extends Label

func _ready() -> void:
	Events.waggons_counted.connect(_on_waggons_counted)

func _on_waggons_counted(waggons: int) -> void:
	self.text = "Waggons: " + str(waggons)
