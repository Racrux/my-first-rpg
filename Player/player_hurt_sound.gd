extends AudioStreamPlayer

func _ready() -> void:
	connect("finished", queue_free)