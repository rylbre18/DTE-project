extends Area2D

@export var road_speed: float = 300.0

func _process(delta: float) -> void:
	# It moves strictly at road speed (like a painted line on the asphalt)
	position.y += road_speed * delta
	
	if position.y > 900:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var main_scene = get_tree().current_scene
		if main_scene.has_method("complete_delivery"):
			main_scene.complete_delivery()
		
		queue_free() # Remove the gate instantly so you can't hit it twice
