extends CharacterBody2D

# multiply delta to make it frame-independent (real-world time)
const ACCELERATION = 500
const MAX_SPEED = 80
const FRICTION = 500

enum{
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE


# GODOTv4 uses @annotation 
# Reference: https://forum.godotengine.org/t/onready-unexpected-identifier/10532/2
@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
# getting access to root infomration for animationTree; can mainpulate proper animations
@onready var animationState = animationTree.get("parameters/playback")


func _ready():
	animationTree.active = true

func _physics_process(delta):
	# works like switch statement 
	match state:
		MOVE:
			move_state(delta)

		ROLL: 
			pass

		ATTACK:
			attack_state(delta)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	# nomalize the vector values to make speed consistent in diff angles
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		# set blend position for idle/run
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		# 2 reasons for not putting this line of code inside the attack_state(delta) function
		#  - Input vector isnt inside attack state
		#  - Don't want player to change direction during animation
		animationTree.set("parameters/Attack/blend_position", input_vector)

		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	# move_and_slide automatically applies delta
	# Godot v4 also automatically uses velocity defined unlike Godot v3.2
	move_and_slide()

	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func attack_state(delta):
	# no velocity during motion
	velocity = Vector2.ZERO
	
	animationState.travel("Attack")

func attack_animation_finished():
	state = MOVE