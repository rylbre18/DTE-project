extends CanvasLayer

@onready var explosion_photo = $'%CrashExplosion'
@onready var background_dim = $'%BackgroundDim'
@onready var game_over_text = $'%GameOverText'
@onready var restart_button = $'%RestartButton'


func _ready() -> void:
	# Print a message to the console to confirm the script is running
	print("Game Over UI Script is ready!")
	
	# Hide individual elements and print an error if they are missing
	if explosion_photo: 
		explosion_photo.hide()
	else:
		print("ERROR: Cannot find %CrashExplosion")
		
	if background_dim: 
		background_dim.hide()
	else:
		print("ERROR: Cannot find %BackgroundDim")
		
	if game_over_text: 
		game_over_text.hide()
	else:
		print("ERROR: Cannot find %GameOverText")
		
	if restart_button: 
		restart_button.hide()
	else:
		print("ERROR: Cannot find %RestartButton")
	
	# Connect the button click
	if restart_button and not restart_button.pressed.is_connected(_on_restart_button_pressed):
		restart_button.pressed.connect(_on_restart_button_pressed)

func _input(event: InputEvent) -> void:
	# If you press the "G" key on your keyboard, force the Game Over screen to run
	if event is InputEventKey and event.pressed and event.keycode == KEY_G:
		print("Manually triggering game over via G key!")
		trigger_game_over()

# FIXED: This runs constantly to force the mouse to stay visible no matter what
func _process(_delta: float) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func trigger_game_over() -> void:
	# Show the explosion photo and dim the background immediately
	if explosion_photo: explosion_photo.show()
	if background_dim: background_dim.show()
	
	# Freeze the traffic
	get_tree().paused = true
	
	# Wait 1.5 seconds while frozen
	var crash_timer = get_tree().create_timer(1.5, true)
	await crash_timer.timeout
	
	# Show the text and restart button
	if game_over_text: game_over_text.show()
	if restart_button: restart_button.show()


func _on_restart_button_pressed() -> void:
	# 1. Unpause the engine directly
	Engine.time_scale = 1.0
	
	# 2. Grab the global SceneTree directly through the Engine singleton
	var global_tree = Engine.get_main_loop() as SceneTree
	
	if global_tree:
		global_tree.paused = false
		global_tree.reload_current_scene()
	else:
		print("CRITICAL: Even the global engine loop couldn't find the scene tree!")
