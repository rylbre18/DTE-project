extends Node2D

var traffic_scene = preload("res://traffic_car.tscn")
var gate_scene = preload("res://drop_off_gate.tscn")

var spawn_count: int = 0

func _ready() -> void:
	$Timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
	if not has_node("SpawnZone"): return
	var spawn_zone = $SpawnZone as ReferenceRect
	
	# 1. THIS LINE MUST COME FIRST! This creates the variable.
	var random_x = randf_range(spawn_zone.global_position.x + 30, spawn_zone.global_position.x + spawn_zone.size.x - 30)
	
	spawn_count += 1
	
	# 2. Now the lines below can safely use "random_x" because it already exists
	if spawn_count % 4 == 0:
		var new_gate = gate_scene.instantiate()
		new_gate.global_position = Vector2(random_x, spawn_zone.global_position.y)
		get_parent().add_child(new_gate)
		print("Spawned a Delivery Gate!")
	else:
		var new_car = traffic_scene.instantiate()
		new_car.global_position = Vector2(random_x, spawn_zone.global_position.y)
		new_car.driving_speed = randf_range(20.0, 220.0)
		get_parent().add_child(new_car)
