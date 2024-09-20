extends Area2D

func is_colliding():
	var areas = get_overlapping_areas()
	# return true; otherwise false
	return areas.size() > 0

func get_push_vector():
	var areas = get_overlapping_areas()
	var push_vector = Vector2.ZERO
	if is_colliding():
		# only get first area
		var area = areas[0]
		# get vector from its position to our position
		push_vector = area.global_position.direction_to(global_position)
		# make vector length of 1 (normalize in math)
		push_vector = push_vector.normalized()
	return push_vector
	
