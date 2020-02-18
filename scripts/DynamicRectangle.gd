extends "res://scripts/BaseRectangle.gd"

enum draw_direction { GROW, SHRINK, SOLID }
var draw_speed = 0.5
var current_dir
var target = Vector2(0, 0)
var my_id

signal finished_growing()
signal finished_shrinking()

func _ready():
	current_dir = draw_direction.SOLID

func set_id(id):
	my_id = id

func set_draw_direction(dir):
	match dir:
		"grow":
			current_dir = draw_direction.GROW
		"shrink":
			current_dir = draw_direction.SHRINK
		"solid":
			current_dir = draw_direction.SOLID

func set_shape(dir: String, shape_length: int) -> void:
	.set_shape(dir, shape_length)
	current_size = start_size
	target = end_size

func set_shape_pos_and_extent() -> void:
	for i in range(0, my_positions.size()):
		my_shapes[i].set_extents(Vector2(current_size.x / 2, current_size.y / 2))
		my_colshapes[i].set_shape(my_shapes[i])
		my_bodies[i].position = Vector2(my_positions[i].x / 2 + current_size.x / 4,  my_positions[i].y / 2 + current_size.y / 4)
		my_colshapes[i].position = my_bodies[i].position

func _process(delta):
	var draw_spd
	if current_dir == draw_direction.SHRINK:
		for i in range(my_positions.size()):
			my_positions[i].y += draw_speed
		current_size.y -= draw_speed
	else:
		draw_spd = draw_speed
		
	if current_dir == draw_direction.GROW:
		if current_size.x <= target.x:
			current_size.x += draw_spd
		if current_size.y <= target.y:
			current_size.y += draw_spd

	if current_size.y >= target.y and current_dir == draw_direction.GROW:
		current_dir = draw_direction.SOLID
		emit_signal("finished_growing")
		target.y = start_size.y
	elif current_size.y <= target.y and current_dir == draw_direction.SHRINK:
		emit_signal("finished_shrinking")
		current_dir = draw_direction.SOLID
		target.y = end_size.y
		for i in range(my_start_positions.size()):
			my_positions[i].y = my_start_positions[i].y

	set_shape_pos_and_extent()
	update()

func on_growth_signal():
	current_dir = draw_direction.GROW
