extends Area2D

# MUST match the scroll_speed of your ParallaxBackground road!
@export var road_speed: float = 900.0

# How fast this AI car drives forward. 
# 0 = Broken down car (flies backward fast)
# 150 = Slower than player (drifts backward down the screen)
@export var driving_speed: float = .0

func _process(delta: float) -> void:
	# Relative speed math: Road Speed minus Car Speed
	var relative_speed = road_speed - driving_speed
	
	# Move the car down the screen
	position.y += relative_speed * delta
	
	# Automatically clean up the car once it passes the bottom of the screen
	# (Assuming a standard screen height, adjust 900 if your screen is taller)
	if position.y > 1500:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") or body.name == "Player":
		print("CRASH DETECTED BY CAR!")
		
		# Directly find the GameOverUI in the running game tree
		var game_over_screen = get_tree().current_scene.find_child("GameOverUI", true, false)
		
		if game_over_screen:
			game_over_screen.trigger_game_over()
		else:
			print("Car crashed, but couldn't find the GameOverUI node in the scene!")
