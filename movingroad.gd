extends TextureRect

@export var scroll_speed: float = 200.0

var _texture_height: float = 0.0

func _ready() -> void:
	if texture == null:
		push_error("MovingRoad error: No texture assigned to the TextureRect!")
		set_process(false)
		return
		
	texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	_texture_height = texture.get_height()
	
	# Start the road slightly offset so there is always texture texture above the screen
	position.y = 0

func _process(delta: float) -> void:
	# Move downward
	position.y += scroll_speed * delta
	
	# As soon as the road moves down by 1 pixel, we can wrap it.
	# By keeping position.y locked between 0 and -_texture_height, 
	# the top of your screen will never see a blank space.
	if position.y >= 0:
		position.y = fmod(position.y, _texture_height) - _texture_height
