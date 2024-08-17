class_name ItemDisplay extends VBoxContainer

@onready var item_name: Label = $ItemName
@onready var item_texture: TextureRect = $ItemTexture
@onready var item_description: Label = $ItemDescription
@onready var item_buy: Button = $ItemBuy

var item_displayed: Item

func _ready() -> void:
	pass

func set_item(item: Item) -> void:
	item_displayed = item
	set_props()

func set_props() -> void:
	item_name.text = item_displayed.name
	item_texture.texture = item_displayed.icon
	item_description.text = item_displayed.tooltip_text
	item_buy.text = "Buy (%s $)" % str(item_displayed.price)


func _on_item_buy_pressed() -> void:
	Events.emit_signal("item_bought", item_displayed)
	item_buy.text = "Sold out"
	item_buy.disabled = true
