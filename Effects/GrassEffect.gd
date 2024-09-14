extends Node2D

@onready var animatedSprite = $AnimatedSprite

func _process(delta):
	animatedSprite.play("Animate")


func _on_animated_sprite_2d_animation_finished():
	queue_free()
