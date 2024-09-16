extends Node2D

# load once and reuse 
const GrassEffect = preload("res://Effects/grass_effect.tscn")


func create_grass_effect():
	# Node
	# In GODOT v4, use "instantiate()" instead of "instance()"
	var grassEffect = GrassEffect.instantiate()
	get_parent().add_child(grassEffect)
	
	# REMEBER TO ATTACH SCRIPT TO EACH AFFECTED NODES!!!
	grassEffect.global_position = global_position

func _on_hurtbox_area_entered(area):
	create_grass_effect()
	queue_free()
