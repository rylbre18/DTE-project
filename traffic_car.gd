extends Area2D

# MUST match the scroll_speed of your ParallaxBackground road!
@export var road_speed: float = 300.0

# How fast this AI car drives forward. 
# 0 = Broken down car (flies backward fast)
# 150 = Slower than player (drifts backward down the screen)
@export var driving_speed: float = 100.0

func _process(delta: float) -> void:
	# Relative speed math: Road Speed minus Car Speed
	var relative_speed = road_speed - driving_speed
	
	# Move the car down the screen
	position.y += relative_speed * delta
	
	# Automatically clean up the car once it passes the bottom of the screen
	# (Assuming a standard screen height, adjust 900 if your screen is taller)
	if position.y > 900:
		queue_free()
