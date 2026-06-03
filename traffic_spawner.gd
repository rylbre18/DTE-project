extends Node2D

# Load the traffic car template
var traffic_scene = preload("res://traffic_car.tscn")

func _ready() -> void:
	# Clean connection to the timer
	$Timer.timeout.connect(_on_timer_timeout)
	
	# Safety check to make sure the SpawnZone node exists
	if not has_node("SpawnZone"):
		push_error("TrafficSpawner Error: Missing 'SpawnZone' child node!")

func _on_timer_timeout() -> void:
	if not has_node("SpawnZone"): return
	
	var spawn_zone = $SpawnZone as ReferenceRect
	
	# 1. Calculate the exact edges of the box you drew in the editor
	var zone_left = spawn_zone.global_position.x
	var zone_right = zone_left + spawn_zone.size.x
	
	# 2. Pick a completely random X coordinate inside that box
	# We subtract 30 pixels from the edges so cars don't spawn half-off the box
	var random_x = randf_range(zone_left + 30, zone_right - 30)
	
	# 3. Create and position the car
	var new_car = traffic_scene.instantiate()
	new_car.position = Vector2(random_x, spawn_zone.global_position.y)
	
	# 4. FIX THE BUNCHING: Give cars vastly different speeds so they spread out
	new_car.driving_speed = randf_range(20.0, 220.0)
	
	# 5. Add to the scene
	get_parent().add_child(new_car)
	
	# Add this line at the very top of your spawner script with the other preloads:
var gate_scene = preload("res://drop_off_gate.tscn")

func _on_timer_timeout() -> void:
	if not has_node("SpawnZone"): return
	var spawn_zone = $SpawnZone as ReferenceRect
	var random_x = randf_range(spawn_zone.global_position.x + 30, spawn_zone.global_position.x + spawn_zone.size.x - 30)
	
	# 20% chance to spawn a Delivery Gate, 80% chance to spawn a Traffic Car
	if randf() < 0.20:
		var new_gate = gate_scene.instantiate()
		new_gate.position = Vector2(random_x, spawn_zone.global_position.y)
		get_parent().add_child(new_gate)
	else:
		var new_car = traffic_scene.instantiate()
		new_car.position = Vector2(random_x, spawn_zone.global_position.y)
		new_car.driving_speed = randf_range(20.0, 220.0)
		get_parent().add_child(new_car)
