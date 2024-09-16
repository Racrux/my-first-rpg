extends CharacterBody2D

var KNOCKBACK_FORCE = 160
var FRICTION = 500

func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()


func _on_hurtbox_area_entered(area):
	var pivot = area.get_parent()
	var player = pivot.get_parent()
	
	velocity = player.roll_vector * KNOCKBACK_FORCE


	#queue_free()
