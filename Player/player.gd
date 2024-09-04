extends CharacterBody2D

# multiply delta to make it frame-independent (real-world time)
const ACCELERATION = 50
const MAX_SPEED = 200
const FRICTION = 400

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	# nomalize the vector values to make speed consistent in diff angles
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		velocity += input_vector * ACCELERATION * delta
		# IMPORTANT: Godot v4 has limit_length() instead of clamped()
		# Reference: https://forum.godotengine.org/t/clamped-doesnt-work-godot-4-0/1284/6
		velocity = velocity.limit_length(MAX_SPEED * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	move_and_collide(velocity)