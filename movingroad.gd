extends TextureRect

## The speed at which the road scrolls down in pixels per second.
@export var scroll_speed: float = 300.0

var _texture_height: float = 0.0

func _ready() -> void:
	# 1. Safety Check
	if texture == null:
		push_error("MovingRoad error: No texture assigned!")
		set_process(false)
		return
		
	# 2. Force Godot to enable texture tiling via code
	texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	
	# 3. Get the exact pixel height of your image asset
	_texture_height = texture.get_height()
	
	# 4. Lock the node to the top of the screen
	position.y = 0

func _process(delta: float) -> void:
	# Move the node down
	position.y += scroll_speed * delta
	
	# The moment the node shifts down by even a single pixel,
	# we instantly calculate its looped position. 
	# This keeps position.y bound strictly between 0 and -_texture_height,
	# ensuring there is ALWAYS texture rendering above the viewport.
	if position.y > 0:
		position.y = fmod(position.y, _texture_height) - _texture_height
