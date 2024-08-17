class_name Train extends CharacterBody2D

var direction:int = 1
var flag_change_dir_on_brake:bool = false
var flag_change_dir_on_acc:bool = false
@export var acc_power := 400.0
@export var brake_power := 800.0
@export var WEIGHT_PER_WAGGON := 50.0
@export var waggon_amount := 2
@onready var weight := waggon_amount * WEIGHT_PER_WAGGON

var acc := 0.0

func _ready() -> void:
	print(weight)
	%TrainShape.scale.y = waggon_amount
	%TrainShape.position.y = waggon_amount * (%TrainShape.shape.size.x / 2)

func _physics_process(delta: float) -> void:
	var new_velocity := velocity.y
	if Input.is_action_pressed("accelerate"):
		$Timer_Brake.stop()
		flag_change_dir_on_brake = false
		if flag_change_dir_on_acc == true:
			direction = direction * (-1)
			flag_change_dir_on_acc = false
		var root := pow(velocity.y, 2) + direction * 2 / weight * acc_power * delta
		if root > 0:
			new_velocity = - direction * sqrt(root)
		else:
			new_velocity = 0
			if $Timer_Acc.time_left == 0:
				$Timer_Acc.start()

	if Input.is_action_pressed("brake"):
		$Timer_Acc.stop()
		flag_change_dir_on_acc = false
		if flag_change_dir_on_brake == true:
			direction = direction * (-1)
			flag_change_dir_on_brake = false
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
