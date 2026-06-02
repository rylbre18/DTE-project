extends Node2D



var traffic_scene = preload("res://traffic_car.tscn")

# Hardcoded values instead of exported ones:
var road_left_edge: float = 215.0
var road_right_edge: float = 1735.0

# 1. Load the traffic car template we made in Part 1
# Double-check that this path matches where you saved your file!


# 2. Define your Road Lanes (X coordinates)
# Look at your 2D workspace and find the exact X positions of your road lanes.
# Replace these placeholder numbers with your actual lane positions!
var lanes: Array[float] = [0.0, 100.0, 200.0, 300.0, 400.0, 500.0, 600.0, 700.0, 800.0, 900]

func _ready() -> void:
	# Connect the timer's timeout signal to our spawn function
	$Timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
	# Pick a random lane from our array
	var random_lane = lanes[randi() % lanes.size()]
	
	# Create a new instance of the traffic car
	var new_car = traffic_scene.instantiate()
	
	# Position it at the random lane, and slightly ABOVE the screen (Y = -100)
	new_car.position = Vector2(random_lane, -100)
	
	# Optional: Give it a random driving speed so traffic isn't uniform
	new_car.driving_speed = randf_range(50.0, 180.0)
	
	# Add the car to the main scene tree
	get_parent().add_child(new_car)
