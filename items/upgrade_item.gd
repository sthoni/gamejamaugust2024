class_name UpgradeItem extends Item

@export var upgrade_power := 1
@export var upgrade_type: ItemType = ItemType.ENGINE

func apply_effects(target: TrainStats) -> void:
	var items_to_upgrade: Array[Item] = target.items.filter(func(item: Item) -> bool: return item.item_type == upgrade_type)
	if !items_to_upgrade.is_empty():
		items_to_upgrade[0].level += upgrade_power
