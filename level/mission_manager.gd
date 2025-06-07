class_name MissionManager extends Node


var mission: Array[StationStats]
var current_station_index: int = 0
var elapsed_time: float = 0.0
var is_mission_active: bool = false

@onready var mission_timer: Timer = Timer.new()

signal mission_completed
signal mission_failed
signal apply_penalty(amount: int)

func _ready() -> void:
	add_child(mission_timer)
	mission_timer.timeout.connect(_on_mission_timer_timeout)

func start_mission() -> void:
	if mission and mission.size() > 0:
		current_station_index = 0
		elapsed_time = 0.0
		is_mission_active = true
		mission_timer.start() # Start a timer for the first leg
		print("Mission started. Go to station: ", mission[current_station_index].name)
	else:
		print("Error: No mission assigned or no stations in mission.")
		is_mission_active = false

func _process(delta: float) -> void:
	if is_mission_active:
		elapsed_time += delta
		# TODO: Update UI with elapsed time and target time for current station

func _on_station_correctly_stopped(station_name: String) -> void:
	if not is_mission_active:
		return

	var expected_station := mission[current_station_index]

	if station_name == expected_station.name:
		print("Arrived at correct station: ", station_name)
		mission_timer.stop()
		calculate_and_apply_penalty(expected_station, elapsed_time)

		current_station_index += 1
		if current_station_index < mission.size():
			elapsed_time = 0.0
			mission_timer.start() # Start timer for the next leg
			print("Next station: ", mission[current_station_index].name)
		else:
			print("Mission Completed!")
			is_mission_active = false
			mission_completed.emit()
	else:
		print("Arrived at incorrect station: ", name)
		# TODO: Handle arriving at the wrong station (e.g., penalty, mission failed)

func _on_station_missed(station_name: String) -> void:
	if not is_mission_active:
		return

	var expected_station := mission[current_station_index]

	if station_name == expected_station.name:
		print("Missed expected station: ", station_name)
		mission_timer.stop()
		apply_miss_penalty(expected_station)
		is_mission_active = false
		mission_failed.emit()
	# TODO: Handle missing a station that was not the current target (optional)


func _on_mission_timer_timeout() -> void:
	if is_mission_active:
		var current_station := mission[current_station_index]
		if elapsed_time > current_station.time_limit:
			print("Time limit exceeded for station: ", current_station.name)
			apply_miss_penalty(current_station) # Or a different penalty for time limit
			is_mission_active = false
			mission_failed.emit()


func calculate_and_apply_penalty(station: StationStats, actual_time: float) -> void:
	var time_difference := actual_time - station.target_time
	if time_difference > 0:
		var penalty := int(time_difference * station.penalty_per_second_late)
		print("Applying time penalty: ", penalty)
		apply_penalty.emit(penalty)
	else:
		print("Arrived on time or early. No time penalty.")

func apply_miss_penalty(station: StationStats) -> void:
	print("Applying miss penalty: ", station.miss_penalty)
	apply_penalty.emit(station.miss_penalty)

# TODO: Connect signals from Station nodes to this manager
# TODO: Connect signals from this manager to GameStats and Level