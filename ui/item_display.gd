class_name ItemDisplay extends PanelContainer

@onready var item_name: Label = %ItemName
@onready var item_texture: TextureRect = %ItemTexture
@onready var item_description: Label = %ItemDescription
@onready var item_buy: Button = %ItemBuy

var item_displayed: Item: set = set_item

signal item_bought(item_displayed: Item)

func _ready() -> void:
	@warning_ignore("return_value_discarded")
	Events.connect("money_changed", check_for_enough_money)

func set_item(item: Item) -> void:
	item_displayed = item
	check_for_enough_money(GameState.game_stats.money, GameState.game_stats.money)
	set_props()

func set_props() -> void:
	item_name.text = item_displayed.name
	item_texture.texture = item_displayed.icon
	item_description.text = item_displayed.tooltip_text
	item_buy.text = "Buy (%s $)" % str(item_displayed.price)


func _on_item_buy_pressed() -> void:
	if item_displayed.price <= GameState.game_stats.money:
		GameState.game_stats.money -= item_displayed.price
		item_bought.emit(item_displayed)
		GameState.game_stats.train_stats.add_item(item_displayed)
		item_buy.text = "Sold out"
		item_buy.disabled = true
		Events.disconnect("money_changed", check_for_enough_money)


func check_for_enough_money(_old_money: int, money: int) -> void:
	if item_displayed and money < item_displayed.price:
		item_buy.disabled = true
	else:
		item_buy.disabled = false
