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
