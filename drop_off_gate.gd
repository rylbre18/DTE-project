extends Area2D

@export var road_speed: float = 900.0
var score_collected: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	position.y += road_speed * delta
	if position.y > 1500:
		position.y = -100
		score_collected = false

func _on_body_entered(body: Node2D) -> void:
	print("GATE BODY ENTERED: ", body.name)
	if (body.is_in_group("player") or body.name == "player") and not score_collected:
		score_collected = true
		var main_game = get_tree().current_scene
		if main_game and main_game.has_method("complete_delivery"):
			main_game.complete_delivery()
			print("GATE HIT - Cash awarded!")
		else:
			print("ERROR: complete_delivery not found on: ", main_game.name)
