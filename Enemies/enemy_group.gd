extends Node2D

var enenmies: Array = []

func _ready() -> void:
	enenmies = get_children()
	for i in enenmies.size():
		enenmies[i].position = Vector2(0, i*52)
