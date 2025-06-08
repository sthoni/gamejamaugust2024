class_name TrainStats extends Resource

@export_group("Train Attributes")
@export var id: String
@export var items: Array[Item]
@export var start_velocity: float

@export_group("Train Visuals")
@export var sprite: Texture

var weight := 0.0:
    get:
        var w := 0.0
        for item in items:
            w += item.weight
        return w

var transport_amount := 0.0:
    get:
        var t := 0.0
        for item in items:
            if item.get("transport_amount"):
                t += item.transport_amount
        return t

var waggon_amount := 0:
    get:
        var a := 0
        for item in items:
            if item.item_type == Item.ItemType.WAGGON:
                a += 1
        return a

var acc_power := 0.0:
    get:
        var p := 0.0
        for item in items:
            if item.get("acc_power"):
                p += item.acc_power + ((item.level - 1) / 4.0) * item.acc_power
        return p

var brake_power := 0.0:
    get:
        var p := 0.0
        for item in items:
            if item.get("brake_power"):
                p += item.brake_power + ((item.level - 1) / 4.0) * item.brake_power
        return p


func add_item(item: Item) -> void:
    item.apply_effects(self)

	# Remove existing items of the same type before adding the new one
    if item.item_type != Item.ItemType.WAGGON:
        _remove_items_by_type(item.item_type)
    if item.item_type != Item.ItemType.UPGRADE:
        items.push_back(item)

    Events.train_stats_changed.emit(self)


func _remove_items_by_type(item_type: int) -> void:
    var items_to_remove: Array[Item] = items.filter(func(item: Item) -> bool: return item.item_type == item_type)
    for item_to_remove: Item in items_to_remove:
        items.erase(item_to_remove)