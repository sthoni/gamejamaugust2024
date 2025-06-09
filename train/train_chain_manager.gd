extends Node

@onready var path_follow_1: PathFollow2D = $Path2D/PathFollow_1 #in TrainChainManager
@onready var path_follow_2: PathFollow2D = $Path2D_2/PathFollow_2
@onready var current_path = path_follow_1
@onready var train_stats: TrainStats = GameState.game_stats.train_stats

var waggon = preload("res://train/waggon.tscn")
var paths: Array[PathFollow2D]

func _ready() -> void:
	path_follow_1.progress = 0 #in TrainChainManager
	apply_items()
	%Train.velocity.y = train_stats.start_velocity
	Events.item_bought.connect(_on_item_bought)
	
func _process(delta):
	var train = get_tree().get_nodes_in_group("Train")[0]
	if Input.is_action_pressed("right"):
		if $Weiche1.get_overlapping_bodies().has(train):
			switch_path(path_follow_2)
			
	if current_path is PathFollow2D:
		current_path.progress += get_tree().get_nodes_in_group("Train")[0].velocity.y * delta
		#end of path: Jump back to root path:
		if current_path.progress_ratio >= 1.0:
			var end_position = current_path.global_position
			switch_path(path_follow_1)
			current_path.progress = 1606
		for i in range(paths.size()):
			paths[i].progress = current_path.progress - (35 + 24 * i)

func apply_items() -> void:
	var train = get_tree().get_nodes_in_group("Train")[0]
	train.weight = train_stats.weight
	train.waggon_amount = train_stats.waggon_amount
	train.acc_power = train_stats.acc_power
	train.brake_power = train_stats.brake_power
	train.transport_amount = train_stats.transport_amount
	paths = []
	if train.is_inside_tree():
		for member in get_tree().get_nodes_in_group("FreightWaggons"):
			member.get_parent().free()
	var i := 0
	for item: Item in train_stats.items:
		if item.item_type == Item.ItemType.WAGGON and train.get_parent():
			var waggon_instance := waggon.instantiate()
			waggon_instance.rotation = deg_to_rad(90)
			var new_current_path = PathFollow2D.new()
			paths.append(new_current_path)
			current_path.get_parent().add_child.call_deferred(new_current_path)
			new_current_path.add_child(waggon_instance)
			current_path.add_child.call_deferred(waggon_instance)
			waggon_instance.add_to_group("FreightWaggons")
			i += 1

	Events.emit_signal("train_stats_changed", train_stats)

func switch_path(new_path: PathFollow2D):
	#var train = current_path.get_child(0) #Train
	var train = current_path.get_node("Train") #Train
	
	if train:
		current_path.remove_child(train)
		new_path.add_child(train)
		#train.position = Vector2.ZERO # Lokale Position im neuen PathFollow2D
		new_path.progress = current_path.progress
		current_path = new_path
	
func _on_item_bought(bought_item: Item) -> void:
	train_stats.add_item(bought_item)


func _on_weiche_1_area_entered(area: Area2D):
	if area.get_groups()[0] == "FreightWaggons":
		var train = get_tree().get_nodes_in_group("Train")[0]
		var trainpath: Path2D = train.get_parent().get_parent()
		if area.get_parent().get_parent() !=  trainpath:
			area.get_parent().reparent(trainpath)# Replace with function body.
