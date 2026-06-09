extends Area2D

var score_collected: bool = false

func _on_body_entered(body: Node2D) -> void:
	# Check if the colliding object is the player
	if (body.is_in_group("player") or body.name == "Player" or body.name == "player") and not score_collected:
		score_collected = true
		print("GATE HIT BY PLAYER!")
		
		# Find the main game scene running at the root of the tree
		var main_scene = get_tree().current_scene
		
		# Talk directly to the main script's score system
		if main_scene and main_scene.has_method("complete_delivery"):
			main_scene.complete_delivery()
		else:
			print("ERROR: Gate couldn't find complete_delivery() on the Main scene!")
			
		# Remove the gate safely from the level
		queue_free()
