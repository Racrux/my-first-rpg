extends CharacterBody2D

const EnemyDeathEffect = preload("res://Effects/enemy_death_effect.tscn")

@export var ACCELERATION = 550
@export var MAX_SPEED = 25
@export var FRICTION = 500

enum{
	IDLE,
	WANDER,
	CHASE
}

@onready var sprite = $AnimatedSprite
@onready var stats = $Stats
@onready var playerDetectionZone = $PlayerDetectionZone
@onready var hurtbox = $Hurtbox
@onready var softCollision = $SoftCollision
@onready var wanderController = $WanderController

var KNOCKBACK_FORCE = 160
var KNOCKBACK_FRICTION = 500

var state = IDLE



func _ready():
	randomize()
	state = pick_rand_state([IDLE, WANDER])


func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, KNOCKBACK_FRICTION * delta)
	move_and_slide()

	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()

			if wanderController.get_time_left() == 0:
				update_wander()

		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()

			accelerate_towards_point(wanderController.target_position, delta)

			if global_position.distance_to(wanderController.target_position) <= MAX_SPEED * delta:
				update_wander()

		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
			else:
				state = IDLE
			# face the player
			sprite.flip_h = velocity.x < 0	
		
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400

	move_and_slide()		

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	# face the player
	sprite.flip_h = velocity.x < 0	

func update_wander():
	state = pick_rand_state([IDLE, WANDER])
	wanderController.start_wander_timer(randf_range(1, 3))

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func pick_rand_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_hurtbox_area_entered(area):
	# damage of hitbox
	stats.health -= area.damage
	#print(stats.health)
	
	var pivot = area.get_parent()
	var player = pivot.get_parent()
	
	velocity = player.roll_vector * KNOCKBACK_FORCE
	hurtbox.create_hit_effect()


func _on_stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instantiate()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
