class_name Train extends CharacterBody2D

var direction:int = 1
var flag_change_dir_on_brake:bool = false
var flag_change_dir_on_acc:bool = false
var flag_tut_played:bool = false
var flag_train_long_tut_played:bool = false
var waggon = preload("res://train/waggon.tscn")
@export var train_stats: TrainStats : set = apply_items
@export var audiobus: AudioBusLayout

@onready var sprite: Sprite2D = $Locomotive
@onready var timer_brake: Timer = $Timer_Brake
@onready var timer_acc: Timer = $Timer_Acc
@onready var tut: AudioStreamPlayer = $Tut1
@onready var longtut: AudioStreamPlayer = $LongTut
@onready var driving_sound: AudioStreamPlayer2D = $Driving
@onready var start_velocity: float = 0.0
@onready var acc_power: float = 0.0
@onready var brake_power: float = 0.0
@onready var waggon_amount: float = 0
@onready var weight: float = 0.0
@onready var transport_amount: float = 0.0

func _ready() -> void:
	Events.train_at_start.connect(_on_train_at_start)
	Events.train_exited.connect(_on_train_exited)
	@warning_ignore("return_value_discarded")
	Events.item_bought.connect(_on_item_bought)
	velocity.y = train_stats.start_velocity
	apply_items(train_stats)

func apply_items(value: TrainStats) -> void:
	train_stats = value
	weight = 0.0
	acc_power = 0.0
	brake_power = 0.0
	waggon_amount = 0
	transport_amount = 0.0
	if sprite:
		sprite.texture = value.sprite
	if get_tree():
		for member in get_tree().get_nodes_in_group("FreightWaggons"):
			member.free()
	var i = 0
	for item: Item in value.items:
		weight += item.weight
		item.apply_effects(self)
		if item.item_type == Item.ItemType.WAGGON:
			var waggon_instance = waggon.instantiate()
			waggon_instance.position.y = 35 + (i * 24)
			add_child(waggon_instance)
			waggon_instance.add_to_group("FreightWaggons")
			i += 1
			waggon_amount += 1
	@warning_ignore("return_value_discarded")
	Events.emit_signal("weight_changed", weight)
	@warning_ignore("return_value_discarded")
	Events.emit_signal("waggons_counted", waggon_amount)

func _physics_process(delta: float) -> void:
	var new_velocity: float = velocity.y
	if velocity.y != 0:
		if driving_sound.playing == false:
			_check_speed()
			driving_sound.play()
	else:
			driving_sound.stop()

	if Input.is_action_pressed("accelerate"):
		timer_brake.stop()
		if flag_tut_played == false:
			tut.play()
			flag_tut_played = true			
		flag_change_dir_on_brake = false
		if flag_change_dir_on_acc == true:
			direction = direction * (-1)
			flag_change_dir_on_acc = false
			tut.play()
		var root: float = pow(velocity.y, 2) + direction * 2 / weight * acc_power * delta
		if root > 0:
			new_velocity = - direction * sqrt(root)
		else:
			flag_tut_played = false	
			new_velocity = 0
			if timer_acc.time_left == 0:
				timer_acc.start()

	if Input.is_action_pressed("brake"):
		timer_acc.stop()
		flag_change_dir_on_acc = false
		if flag_change_dir_on_brake == true:
			direction = direction * (-1)
			flag_change_dir_on_brake = false
			tut.play()
			flag_tut_played = true
		var root: float = pow(velocity.y, 2) - direction * 2 / weight * brake_power * delta
		if root > 0:
			new_velocity = - direction * sqrt(root)
		else:
			flag_tut_played = false	
			new_velocity = 0
			if timer_brake.time_left == 0:
				timer_brake.start()
	
	var acc: float = (new_velocity - velocity.y) / delta
	velocity.y = new_velocity
	@warning_ignore("return_value_discarded")
	Events.emit_signal("accelaration_changed", acc)
	@warning_ignore("return_value_discarded")
	Events.emit_signal("velocity_changed", velocity.y)
	@warning_ignore("return_value_discarded")
	move_and_slide()

func _check_speed():
	var f = AudioServer.get_bus_index("DrivingSounds")
	var eff = AudioServer.get_bus_effect(f, 0)
	if abs(velocity.y) > 100:
		driving_sound.stream = load('res://assets/music/drivingspeeds/spd-10.wav')
		eff.pitch_scale = abs(velocity.y)/100
		pass
	elif abs(velocity.y) > 90:
		driving_sound.stream = load('res://assets/music/drivingspeeds/spd-10.wav')
	elif abs(velocity.y) > 80:
		driving_sound.stream = load('res://assets/music/drivingspeeds/spd-9.wav')
	elif abs(velocity.y) > 70:
		driving_sound.stream = load('res://assets/music/drivingspeeds/spd-8.wav')
	elif abs(velocity.y) > 60:
		driving_sound.stream = load('res://assets/music/drivingspeeds/spd-7.wav')
	elif abs(velocity.y) > 50:
		driving_sound.stream = load('res://assets/music/drivingspeeds/spd-6.wav')
	elif abs(velocity.y) > 40:
		driving_sound.stream = load('res://assets/music/drivingspeeds/spd-5.wav')
	elif abs(velocity.y) > 30:
		driving_sound.stream = load('res://assets/music/drivingspeeds/spd-4.wav')
	elif abs(velocity.y) > 20:
		driving_sound.stream = load('res://assets/music/drivingspeeds/spd-3.wav')
	elif abs(velocity.y) > 10:
		driving_sound.stream = load('res://assets/music/drivingspeeds/spd-2.wav')
	elif abs(velocity.y) > 0:
		driving_sound.stream = load('res://assets/music/drivingspeeds/spd-1.wav')
	eff.pitch_scale = 1

func _on_timer_brake_timeout():
	#just set flag, because if you change dir here, you have to wait for 1 timer period to continue driving in same dir after braking down to v = 0
	flag_change_dir_on_brake = true

func _on_timer_acc_timeout() -> void:
	#just set flag, because if you change dir here, you have to wait for 1 timer period to continue driving in same dir after braking down to v = 0
	flag_change_dir_on_acc = true

func _on_train_at_start() -> void:
	if not flag_train_long_tut_played:
		longtut.play()
		flag_train_long_tut_played = true
	
func _on_train_exited() -> void:
	flag_train_long_tut_played = false

func _on_item_bought(bought_item: Item) -> void:
	if bought_item.item_type == Item.ItemType.TRAIN:
		var trains_in_items: Array[Item] = train_stats.items.filter(func(item: Item) -> bool: return item.item_type == Item.ItemType.TRAIN)
		for item_train: Item in trains_in_items:
			train_stats.items.erase(item_train)
	if bought_item.item_type == Item.ItemType.ENGINE:
		var engines_in_items: Array[Item] = train_stats.items.filter(func(item: Item) -> bool: return item.item_type == Item.ItemType.ENGINE)
		for item_engine: Item in engines_in_items:
			train_stats.items.erase(item_engine)
	if bought_item.item_type == Item.ItemType.BRAKES:
		var brakes_in_items: Array[Item] = train_stats.items.filter(func(item: Item) -> bool: return item.item_type == Item.ItemType.BRAKES)
		for item_engine: Item in brakes_in_items:
			train_stats.items.erase(item_engine)
	train_stats.items.push_back(bought_item)
	apply_items(train_stats)
