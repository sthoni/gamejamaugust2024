class_name Train extends CharacterBody2D

var direction:int = 1
var flag_change_dir_on_brake:bool = false
var flag_change_dir_on_acc:bool = false
var flag_tut_played:bool = false

@export var train_stats: TrainStats : set = apply_items

@onready var sprite: Sprite2D = $Locomotive
@onready var start_velocity := 0.0
@onready var acc_power := 0.0
@onready var brake_power := 0.0
@onready var waggon_amount := 0
@onready var weight := 0.0
@onready var transport_amount := 0.0

func _ready() -> void:
	Events.item_bought.connect(_on_item_bought)
	velocity.y = train_stats.start_velocity
	apply_items(train_stats)


func apply_items(value: TrainStats) -> void:
	train_stats = value
	weight = 0.0
	acc_power = 0.0
	brake_power = 0.0
	waggon_amount = 0
	if sprite:
		sprite.texture = value.sprite
	for item in value.items:
		weight += item.weight
		item.apply_effects(self)
		if item.item_type == Item.ItemType.WAGGON:
			waggon_amount += 1
	Events.emit_signal("weight_changed", weight)
	Events.emit_signal("waggons_counted", waggon_amount)


func _physics_process(delta: float) -> void:
	var new_velocity := velocity.y
	if Input.is_action_pressed("accelerate"):
		$Timer_Brake.stop()
		if flag_tut_played == false:
			$Tut1.play()
			flag_tut_played = true			
		flag_change_dir_on_brake = false
		if flag_change_dir_on_acc == true:
			direction = direction * (-1)
			flag_change_dir_on_acc = false
			$Tut1.play()
		var root := pow(velocity.y, 2) + direction * 2 / weight * acc_power * delta
		if root > 0:
			new_velocity = - direction * sqrt(root)
		else:
			flag_tut_played = false	
			new_velocity = 0
			if $Timer_Acc.time_left == 0:
				$Timer_Acc.start()

	if Input.is_action_pressed("brake"):
		$Timer_Acc.stop()
		flag_change_dir_on_acc = false
		if flag_change_dir_on_brake == true:
			direction = direction * (-1)
			flag_change_dir_on_brake = false
			$Tut1.play()
		var root := pow(velocity.y, 2) - direction * 2 / weight * brake_power * delta
		if root > 0:
			new_velocity = - direction * sqrt(root)
		else:
			new_velocity = 0
			if $Timer_Brake.time_left == 0:
				$Timer_Brake.start()
	
	var acc := (new_velocity - velocity.y) / delta
	velocity.y = new_velocity

	Events.emit_signal("accelaration_changed", acc)
	Events.emit_signal("velocity_changed", velocity.y)

	move_and_slide()


func _on_timer_brake_timeout():
	#just set flag, because if you change dir here, you have to wait for 1 timer period to continue driving in same dir after braking down to v = 0
	flag_change_dir_on_brake = true


func _on_timer_acc_timeout():
	#just set flag, because if you change dir here, you have to wait for 1 timer period to continue driving in same dir after braking down to v = 0
	flag_change_dir_on_acc = true

func _on_item_bought(item: Item):
	if item.item_type == Item.ItemType.TRAIN:
		var trains_in_items := train_stats.items.filter(func(item): return item.item_type == Item.ItemType.TRAIN)
		for item_train in trains_in_items:
			train_stats.items.erase(item_train)
	if item.item_type == Item.ItemType.ENGINE:
		var engines_in_items := train_stats.items.filter(func(item): return item.item_type == Item.ItemType.ENGINE)
		for item_engine in engines_in_items:
			train_stats.items.erase(item_engine)
	train_stats.items.push_back(item)
	apply_items(train_stats)
