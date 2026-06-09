extends Node2D

# --- Bulletproof File Connections ---
var car_scene: PackedScene = preload("res://traffic_car.tscn")
@export var gate_scene: PackedScene = preload("res://drop_off_gate.tscn")

# --- Spawn Settings ---
@export var gate_spawn_chance: float = 0.3
@export var highway_width: float = 400.0


func _ready() -> void:
	# This forces Godot to completely scramble its random number generator 
	# so it doesn't repeat the same numbers or lines!
	randomize()
	
	if has_node("Timer"):
		var timer_node = get_node("Timer")
		timer_node.timeout.connect(_on_timer_timeout)
		print("Spawner: Connected to Timer successfully!")


func _on_timer_timeout() -> void:
	spawn_car()

	if randf() < gate_spawn_chance:
		spawn_gate()


func spawn_car() -> void:
	if car_scene == null:
		return
		
	var car = car_scene.instantiate()
	add_child(car)
	
	# CHANGED: Increased from 250 to 400 to stretch them to the edges of the road
	var random_x = randf_range(-700.0, 700.0)
	
	car.position = Vector2(random_x, 0)
	print("Car spawned at random X: ", random_x)


func spawn_gate() -> void:
	if gate_scene == null:
		return
		
	var gate = gate_scene.instantiate()
	add_child(gate)
	
	# SPREAD FOR GATES
	var random_x = randf_range(-250.0, 250.0)
	gate.position = Vector2(random_x, 0)
