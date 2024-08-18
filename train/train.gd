class_name Train extends CharacterBody2D

var direction:int = 1
var flag_change_dir_on_brake:bool = false
var flag_change_dir_on_acc:bool = false
var flag_tut_played:bool = false
var waggon = preload("res://train/waggon.tscn")

@export var acc_power := 400.0
@export var brake_power := 800.0
@export var waggon_amount := 1
@export var items: Array[Item]
@export var start_velocity := -5.0

@onready var train_shape := $TrainShape
@onready var weight := 50.0
@onready var transport_amount := 10.0

var acc := 0.0

func _ready() -> void:
	Events.item_bought.connect(_on_item_bought)
	apply_items()
	velocity.y = start_velocity
	waggon_amount = count_waggons()

func apply_items() -> void:
	for member in get_tree().get_nodes_in_group("FreightWaggons"):
		member.free(	)
	var i = 0
	for item in items:
		item.apply_effects(self)
		if item.item_type == Item.ItemType.WAGGON:
			var waggon_instance = waggon.instantiate()
			waggon_instance.position.y = 35 + (i * 24)
			add_child(waggon_instance)
			waggon_instance.add_to_group("FreightWaggons")
			i += 1
	Events.emit_signal("weight_changed", weight)


func count_waggons() -> int:
	var counted_waggons := 0
	for item in items:
		if item.item_type == Item.ItemType.WAGGON:
			counted_waggons += 1
	Events.emit_signal("waggons_counted", counted_waggons)
	return counted_waggons

func _physics_process(delta: float) -> void:
	var new_velocity := velocity.y
	if velocity.y != 0:
		if $Locomotive/Driving.playing == false:
			_check_speed()
			$Locomotive/Driving.play()
	else:
			$Locomotive/Driving.stop()

	if Input.is_action_pressed("accelerate"):
		$Timer_Brake.stop()
		if flag_tut_played == false:
			$Locomotive/Tut1.play()
			flag_tut_played = true			
		flag_change_dir_on_brake = false
		if flag_change_dir_on_acc == true:
			direction = direction * (-1)
			flag_change_dir_on_acc = false
			$Locomotive/Tut1.play()
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
			$Locomotive/Tut1.play()
		var root := pow(velocity.y, 2) - direction * 2 / weight * brake_power * delta
		if root > 0:
			new_velocity = - direction * sqrt(root)
		else:
			new_velocity = 0
			if $Timer_Brake.time_left == 0:
				$Timer_Brake.start()
	
	acc = (new_velocity - velocity.y) / delta
	velocity.y = new_velocity

	Events.emit_signal("accelaration_changed", acc)
	Events.emit_signal("velocity_changed", velocity.y)

	move_and_slide()

func _check_speed():
	if abs(velocity.y) > 90:
		$Locomotive/Driving.stream = load('res://assets/music/drivingspeeds/spd-10.wav')
	elif abs(velocity.y) > 80:
		$Locomotive/Driving.stream = load('res://assets/music/drivingspeeds/spd-9.wav')
	elif abs(velocity.y) > 70:
		$Locomotive/Driving.stream = load('res://assets/music/drivingspeeds/spd-8.wav')
	elif abs(velocity.y) > 60:
		$Locomotive/Driving.stream = load('res://assets/music/drivingspeeds/spd-7.wav')
	elif abs(velocity.y) > 50:
		$Locomotive/Driving.stream = load('res://assets/music/drivingspeeds/spd-6.wav')
	elif abs(velocity.y) > 40:
		$Locomotive/Driving.stream = load('res://assets/music/drivingspeeds/spd-5.wav')
	elif abs(velocity.y) > 30:
		$Locomotive/Driving.stream = load('res://assets/music/drivingspeeds/spd-4.wav')
	elif abs(velocity.y) > 20:
		$Locomotive/Driving.stream = load('res://assets/music/drivingspeeds/spd-3.wav')
	elif abs(velocity.y) > 10:
		$Locomotive/Driving.stream = load('res://assets/music/drivingspeeds/spd-2.wav')
	elif abs(velocity.y) > 0:
		$Locomotive/Driving.stream = load('res://assets/music/drivingspeeds/spd-1.wav')
func _on_timer_brake_timeout():
	#just set flag, because if you change dir here, you have to wait for 1 timer period to continue driving in same dir after braking down to v = 0
	flag_change_dir_on_brake = true


func _on_timer_acc_timeout():
	#just set flag, because if you change dir here, you have to wait for 1 timer period to continue driving in same dir after braking down to v = 0
	flag_change_dir_on_acc = true

func _on_item_bought(item: Item):
	items.push_back(item)
	#item.apply_effects(self)
	apply_items()

	waggon_amount = count_waggons()
	#for i in range(waggon_amount):
		#var waggon_instance = waggon.instantiate()
		#waggon_instance.position.y = 35 + (i * 24)
		#add_child(waggon_instance)
