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

var KNOCKBACK_FORCE = 160
var KNOCKBACK_FRICTION = 500

var state = IDLE



func _ready():
	print(stats.max_health)
	print(stats.health)

func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, KNOCKBACK_FRICTION * delta)
	move_and_slide()

	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()

		WANDER:
			pass

		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				# direction to player
				var direction = position.direction_to(player.global_position)
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				state = IDLE
			# face the player
			sprite.flip_h = velocity.x < 0		

	move_and_slide()		

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
	
func _on_hurtbox_area_entered(area):
	# damage of hitbox
	stats.health -= area.damage
	#print(stats.health)
	
	var pivot = area.get_parent()
	var player = pivot.get_parent()
	
	velocity = player.roll_vector * KNOCKBACK_FORCE

func _on_stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instantiate()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
