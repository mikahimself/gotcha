extends "res://scripts/BaseRectangle.gd"

func set_shape(dir: String, shape_length: int) -> void:
	.set_shape(dir, shape_length)
	current_size = end_size
