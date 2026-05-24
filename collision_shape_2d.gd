extends CharacterBody2D

@export var speed = 400.0
@export var rotation_speed = 3.0

var steering_input = 0.0

func _physics_process(delta):
	get_input()
	
	# Rotate the car only if it's moving
	if velocity.length() > 0:
		var new_rotation = steering_input * rotation_speed * delta
		# Scale rotation by velocity to simulate real steering
		rotation += new_rotation * (velocity.length() / speed)
	
	velocity = transform.x * speed
	move_and_slide()

func get_input():
	# Steering
	steering_input = 0.0
	if Input.is_action_pressed("ui_right"):
		steering_input += 1.0
	if Input.is_action_pressed("ui_left"):
		steering_input -= 1.0
	
	# Acceleration/Deceleration
	if Input.is_action_pressed("ui_up"):
		speed = 400.0
	elif Input.is_action_pressed("ui_down"):
		speed = 150.0 # Reverse or braking speed
	else:
		speed = move_toward(speed, 0, 200 * delta)
