extends Node2D

const line_width = 8
const screen_size = 768
const margin = 16
var start_size = Vector2(0, 0)
var end_size = Vector2(0, 0)
var current_size = start_size
var my_start_positions = []
var my_positions = []
var my_bodies = []
var my_shapes = []
var my_colshapes = []

onready var col_shape = CollisionShape2D.new()
onready var rect_shape = RectangleShape2D.new()
onready var static_body = StaticBody2D.new()

func _ready():
	pass

func set_me(pos_x, pos_y, dir, size, buffer, items):
	set_shape(dir, size)
	var width = 10 if dir == "down" else size 
	
	for i in range(0, items):
		var position = Vector2(((i * buffer) + (width * i)) + pos_x, pos_y)
		my_positions.append(position)
		my_start_positions.append(position)
		create_body_and_shape()

	set_shape_position()
	set_shape_pos_and_extent()
		
func create_body_and_shape():
	var sb = StaticBody2D.new()
	var cs = CollisionShape2D.new()
	var rs = RectangleShape2D.new()
	add_child(sb)
	sb.add_child(cs)
	my_bodies.append(sb)
	my_shapes.append(rs)
	my_colshapes.append(cs)
	

func set_shape_position():
	for i in range(0, my_positions.size()):
		my_bodies[i].position = Vector2(my_positions[i].x / 2 + current_size.x / 4, my_positions[i].y / 2 + current_size.y / 4)
		my_colshapes[i].position = my_bodies[i].position

func set_shape(dir: String, shape_length: int) -> void:
	match dir:
		"down":
			start_size = Vector2(line_width, 0)
			end_size = Vector2(line_width, shape_length)
		"right":
			start_size = Vector2(0, line_width)
			end_size = Vector2(shape_length, line_width)
		"h_down":
			start_size = Vector2(shape_length, 0)
			end_size = Vector2(shape_length, line_width)

func set_shape_pos_and_extent() -> void:
	for i in range(0, my_positions.size()):
		my_shapes[i].set_extents(Vector2(current_size.x / 2, current_size.y / 2))
		my_colshapes[i].set_shape(my_shapes[i])

func _draw():
	for r in my_positions:
		draw_rect(Rect2(r.x, r.y, current_size.x, current_size.y), Color("#c501e2"))

