extends CharacterBody2D

@onready var stats = $Stats

var KNOCKBACK_FORCE = 160
var FRICTION = 500

func _ready():
	print(stats.max_health)
	print(stats.health)

func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()


func _on_hurtbox_area_entered(area):
	# damage of hitbox
	stats.health -= area.damage
	#print(stats.health)
	
	

	var pivot = area.get_parent()
	var player = pivot.get_parent()
	
	velocity = player.roll_vector * KNOCKBACK_FORCE

func _on_stats_no_health():
	queue_free()