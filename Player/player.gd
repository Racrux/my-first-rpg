extends CharacterBody2D

# multiply delta to make it frame-independent (real-world time)
const ACCELERATION = 500
const MAX_SPEED = 80
const FRICTION = 500

# GODOTv4 uses @annotation 
# Reference: https://forum.godotengine.org/t/onready-unexpected-identifier/10532/2
@onready var animationPlayer = $AnimationPlayer

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	# nomalize the vector values to make speed consistent in diff angles
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		if input_vector.x > 0:
			animationPlayer.play("RunRight")
		else:
			animationPlayer.play("RunLeft")

		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	
	else:
		animationPlayer.play("IdleRight")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	# move_and_slide automatically applies delta
	# Godot v4 also automatically uses velocity defined unlike Godot v3.2
	move_and_slide()
