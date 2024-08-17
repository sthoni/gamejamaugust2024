class_name Train extends CharacterBody2D

var direction:int = 1
var flag_change_dir_on_brake:bool = false
var flag_change_dir_on_acc:bool = false
var flag_tut_played:bool = false

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
	waggon_amount = count_waggons()
	velocity.y = start_velocity


func apply_items() -> void:
	for item in items:
		item.apply_effects(self)
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


func _on_timer_brake_timeout():
	#just set flag, because if you change dir here, you have to wait for 1 timer period to continue driving in same dir after braking down to v = 0
	flag_change_dir_on_brake = true


func _on_timer_acc_timeout():
	#just set flag, because if you change dir here, you have to wait for 1 timer period to continue driving in same dir after braking down to v = 0
	flag_change_dir_on_acc = true

func _on_item_bought(item: Item):
	items.push_back(item)
	item.apply_effects(self)
	waggon_amount = count_waggons()
