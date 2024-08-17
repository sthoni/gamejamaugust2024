class_name Train extends CharacterBody2D

@export var acc_power := 40.0
@export var brake_power := 80.0
@export var WEIGHT_PER_WAGGON := 50.0
@export var waggon_amount := 2
@onready var weight := waggon_amount * WEIGHT_PER_WAGGON

var acc := 0.0

signal velocity_changed(velocity: float)
signal accelaration_changed(acc: float)

func _ready() -> void:
	print(weight)
	%TrainShape.scale.y = waggon_amount

func _physics_process(delta: float) -> void:
	var new_velocity := velocity.y
	if Input.is_action_pressed("accelerate"):
		new_velocity = -sqrt(pow(velocity.y, 2) + acc_power * delta)

	if Input.is_action_pressed("brake"):
		var root = pow(velocity.y, 2) - brake_power * delta
		if root > 0:
			new_velocity = -sqrt(root)
		else:
			new_velocity = 0
	
	acc = (new_velocity - velocity.y) / delta
	velocity.y = new_velocity

	emit_signal("accelaration_changed", acc)
	emit_signal("velocity_changed", velocity.y)

	move_and_slide()
