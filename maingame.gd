extends Node2D

@export var score_label: Label # We will use this to show Time & Cash

var time_left: float = 30.0
var cash_earned: int = 0
var is_game_over: bool = false

func _process(delta: float) -> void:
	if is_game_over: return
	
	# Countdown the delivery timer
	time_left -= delta
	
	# Update the UI
	if score_label != null:
		score_label.text = "Time Left: " + str(ceil(time_left)) + "s\nCash: $" + str(cash_earned)
	
	# Lose if time runs out
	if time_left <= 0:
		delivery_failed("TIME'S UP!")

# Called when player successfully hits a DropOffGate
func complete_delivery() -> void:
	if is_game_over: return
	cash_earned += 100
	time_left += 15.0 # Reward the player with extra time!
	print("Delivery Complete! +$100")

func delivery_failed(reason: String) -> void:
	is_game_over = true
	if score_label != null:
		score_label.text = reason + "\nFinal Earnings: $" + str(cash_earned)
	get_tree().paused = true
