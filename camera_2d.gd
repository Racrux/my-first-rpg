extends Camera2D

@onready var Top_Left = $Limits/topLeft
@onready var Bottom_Right = $Limits/bottomRight

func _ready() -> void:
	limit_top = Top_Left.position.y
	limit_left = Top_Left.position.x
	limit_bottom = Bottom_Right.position.y
	limit_right = Bottom_Right.position.x