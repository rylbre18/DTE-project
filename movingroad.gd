extends TextureRect

@export var scroll_speed: float = 700.0

var _texture_height: float = 0.0
var _scaled_height: float = 0.0

func _ready() -> void:
	if texture == null:
		push_error("MovingRoad error: No texture assigned!")
		set_process(false)
		return
		
	texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	
	# 1. Get the base height of your image
	_texture_height = texture.get_height()
	
	# 2. Calculate the ACTUAL height on screen based on your Scale Y property
	_scaled_height = _texture_height * scale.y
	
	position.y = 0

func _process(delta: float) -> void:
	# Move downward
	position.y += scroll_speed * delta
	
	# Fix: The loop reset must happen relative to the SCALED height, 
	# otherwise it snaps back too early or too late, causing glitches.
	if position.y > 0:
		position.y = fmod(position.y, _scaled_height) - _scaled_height
