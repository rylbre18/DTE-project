extends Node2D

# --- Inspector Connections ---
@export var score_label: Label
@export var game_over_screen: Panel
@export var final_score_label: Label

# --- Game Variables ---
var time_left: float = 30.0
var cash_earned: int = 0
var is_game_over: bool = false

func _ready() -> void:
	add_to_group("game")
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

func complete_delivery() -> void:
	if is_game_over:
		return
	cash_earned += 100
	time_left += 5.0
	print("Delivery complete! Cash: $", cash_earned)

func delivery_failed(reason: String) -> void:
	is_game_over = true
	if score_label != null:
		score_label.visible = false
	if game_over_screen != null:
		game_over_screen.visible = true
	if final_score_label != null:
		final_score_label.text = "GAME OVER\n" + reason + "\nTotal Cash: $" + str(cash_earned)
	get_tree().paused = true

func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_timer_timeout() -> void:
	pass

func trigger_crash() -> void:
	var explosion = get_node_or_null("../CrashExplosion")
	if explosion:
		explosion.show()
	get_tree().paused = true
	await get_tree().create_timer(2.0).timeout
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_drop_off_gate_body_entered(_body: Node2D) -> void:
	print("Gate signal fired! Body: ", _body.name)
	if _body.is_in_group("player") or _body.name == "player":
		complete_delivery()
		print("GATE HIT BY PLAYER!")
