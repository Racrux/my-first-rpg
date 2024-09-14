extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("attack"):
		# Scene
		var GrassEffect = load("res://Effects/grass_effect.tscn")
		# Node
		# In GODOT v4, use "instantiate()" instead of "instance()"
		var grassEffect = GrassEffect.instantiate()
		
		# Gets current main scene of scene tree (remote, NOT local)
		var world = get_tree().current_scene
		# add the instance of GrassEffect scene
		world.add_child(grassEffect)
		# set grass effect's global position to global position of the grass
		
		# REMEBER TO ATTACH SCRIPT TO EACH AFFECTED NODES!!!
		grassEffect.global_position = global_position
		queue_free()
