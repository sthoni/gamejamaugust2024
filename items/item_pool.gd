class_name ItemPool extends Resource

@export_group("ItemPool Attributes")
@export var id: String
@export var items: Array[Item]

func get_random_item() -> Item:
	var item: Item = items[randi() % items.size()]
	return item

func get_two_unique_random_items() -> Array[Item]:
	var item_1: Item = get_random_item()
	var item_2: Item = get_random_item()
	while item_2 == item_1:
		item_2 = get_random_item()
	return [item_1, item_2]
