extends Node2D

# --- Inspector Connections ---
# Drag and drop your UI elements into these slots in the Inspector panel
@export var score_label: Label 
@export var game_over_screen: Panel
@export var final_score_label: Label

# --- Game Variables ---
var time_left: float = 30.0
var cash_earned: int = 0
var is_game_over: bool = false

func _ready() -> void:
	print("MainGame script has successfully started!")
	get_tree().paused = false
	is_game_over = false
	time_left = 30.0
	cash_earned = 0

func _process(delta: float) -> void:
	if is_game_over:
		return

	time_left -= delta

	if score_label != null:
		score_label.text = "Time: " + str(ceil(time_left)) + " | Cash: $" + str(cash_earned)

	if time_left <= 0:
		print("Timer hit 0! Triggering game over...")
		delivery_failed("TIME'S UP!")


# Called by the Gate script when the player successfully drives through it
func complete_delivery() -> void:
	if is_game_over:
		return
		
	cash_earned += 100  # Reward money
	time_left += 5.0    # Reward bonus time
	print("Delivery complete! Cash: $", cash_earned)


# Called when the player runs out of time or crashes into a traffic car
func delivery_failed(reason: String) -> void:
	is_game_over = true
	
	# Hide the normal running scoreboard
	if score_label != null:
		score_label.visible = false
		
	# Reveal the Game Over menu overlay
	if game_over_screen != null:
		game_over_screen.visible = true
		
	# Build and set the final score announcement text
	if final_score_label != null:
		final_score_label.text = "GAME OVER\n" + reason + "\nTotal Cash: $" + str(cash_earned)
	
	# Freeze the physics, traffic, and background movement behind the menu
	get_tree().paused = true


# Connected to your UI RestartButton's pressed() signal
func _on_restart_button_pressed() -> void:
	# Unpause the engine BEFORE reloading, or the new match starts frozen!
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_timer_timeout() -> void:
	pass 
	

func trigger_crash() -> void:
	# 1. Find your hidden explosion sprite and make it pop up
	var explosion = get_node_or_null("../CrashExplosion")
	if explosion:
		explosion.show()
	
	# 2. Freeze the rest of the game action so everything stops moving
	get_tree().paused = true
	
	# 3. Wait for 2 seconds so the player can look at the explosion photo
	await get_tree().create_timer(2.0).timeout
	
	# 4. Unpause the game engine so things can run again
	get_tree().paused = false
	
	# 5. Restart the level fresh
	get_tree().reload_current_scene()
