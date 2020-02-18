extends Node2D

var maze_cell = load("res://scripts/MazeCell.gd")
var stat_rect = load("res://scripts/StaticRectangle.gd")
var dyna_rect = load("res://scripts/DynamicRectangle.gd")

onready var tilemap = $TileMap

enum CellState {
	PATH_N = 1,
	PATH_E = 2,
	PATH_S = 4,
	PATH_W = 8,
	VISITED = 10
}

const MAZE_W: int = 20
const MAZE_H: int = 13
var visited_cells: int = 0
var maze_stack: Array = []
var maze: Array = []
var path_w = 28

func _ready():
	randomize()
	initialize_maze()
	add_static_rects()
	add_dynamic_rects()

func initialize_maze():
	for i in range(MAZE_H * MAZE_W):
		maze.append(maze_cell.new())
	maze_stack.append(Vector2(0,0))
	maze[0].VISITED = 1
	visited_cells += 1
	while(visited_cells < MAZE_H * MAZE_W):
		create_maze()
	
func _process(delta):
	#create_maze()
	pass

func add_static_rects():

	var rect_elem1 = stat_rect.new()
	var rect_elem2 = stat_rect.new()
	var rect_elem3 = stat_rect.new()
	var rect_elem4 = stat_rect.new()
	var rect_elem5 = stat_rect.new()
	var rect_elem6 = stat_rect.new()

	add_child(rect_elem1)
	add_child(rect_elem2)
	add_child(rect_elem3)
	add_child(rect_elem4)
	add_child(rect_elem5)
	add_child(rect_elem6)

	rect_elem1.set_me(8, 30, "right", 32, 148, 5)
	rect_elem2.set_me(40, 30, "down", 48, 170, 5)
	rect_elem3.set_me(94, 70, "right", 48, 132, 5)
	rect_elem4.set_me(8, 70, "down", 48, 170, 5)
	rect_elem5.set_me(16, 110, "right", 32, 148, 5)
	rect_elem6.set_me(94, 110, "right", 48, 132, 5)

func add_dynamic_rects() -> void:

	var d_rect_elem1 = dyna_rect.new()
	var d_rect_elem2 = dyna_rect.new()
	var d_rect_elem3 = dyna_rect.new()
	var d_rect_elem4 = dyna_rect.new()
	var d_rect_elem5 = dyna_rect.new()
	var d_rect_elem6 = dyna_rect.new()
	var d_rect_elem7 = dyna_rect.new()
	var d_rect_elem8 = dyna_rect.new()

	add_child(d_rect_elem1)
	add_child(d_rect_elem2)
	add_child(d_rect_elem3)
	add_child(d_rect_elem4)
	add_child(d_rect_elem5)
	add_child(d_rect_elem6)
	add_child(d_rect_elem7)
	add_child(d_rect_elem8)

	d_rect_elem1.set_me(40, 10, "down", 20, 170, 4)
	d_rect_elem2.set_me(134, 10, "down", 60, 170, 4)
	d_rect_elem3.set_me(94, 78, "h_down", 48, 132, 4)
	d_rect_elem4.set_me(134, 86, "down", 24, 170, 4)
	d_rect_elem5.set_me(94, 118, "down", 48, 170, 4)
	d_rect_elem6.set_me(134, 118, "down", 48, 170, 4)
	d_rect_elem7.set_me(94, 166, "h_down", 48, 132, 4)
	d_rect_elem8.set_me(134, 174, "down", 48, 170, 4)

	d_rect_elem1.set_draw_direction("grow")
	d_rect_elem2.set_draw_direction("grow")
	d_rect_elem2.connect("finished_growing", d_rect_elem3, "on_growth_signal")
	d_rect_elem3.connect("finished_growing", d_rect_elem4, "on_growth_signal")
	d_rect_elem4.connect("finished_growing", d_rect_elem5, "on_growth_signal")
	d_rect_elem4.connect("finished_growing", d_rect_elem6, "on_growth_signal")
	d_rect_elem5.connect("finished_growing", d_rect_elem7, "on_growth_signal")
	d_rect_elem7.connect("finished_growing", d_rect_elem8, "on_growth_signal")


func maze_offset(offset_x: int, offset_y: int) -> int:
	return (maze_stack.back().y + offset_y) * MAZE_W + (maze_stack.back().x + offset_x)

func draw_maze_as_tilemap():
	for x in range(0, MAZE_W):
		for y in range(0, MAZE_H):
			tilemap.set_cell(x, y, maze[y * MAZE_W + x].get_cell_value())

func create_maze():
	var neighbors = []

	if (visited_cells < MAZE_W * MAZE_H):
		if maze_stack.back().y > 0 and maze[maze_offset(0, -1)].VISITED == 0:
			neighbors.append(0)
		if maze_stack.back().x  < MAZE_W - 1 and maze[maze_offset(1, 0)].VISITED == 0:
			neighbors.append(1)
		if maze_stack.back().y < MAZE_H - 1 and maze[maze_offset(0, 1)].VISITED == 0:
			neighbors.append(2)
		if maze_stack.back().x > 0 and maze[maze_offset(-1, 0)].VISITED == 0:
			neighbors.append(3)

	if not neighbors.empty():
		var next_cell_dir = neighbors[randi() % neighbors.size()]

		match next_cell_dir:
			0:
				maze[maze_offset(0, -1)].PATH_S = 1
				maze[maze_offset(0, 0)].PATH_N = 1
				maze_stack.append(Vector2(maze_stack.back().x + 0, maze_stack.back().y - 1))
			1:
				maze[maze_offset(1, 0)].PATH_W = 1
				maze[maze_offset(0, 0)].PATH_E = 1
				maze_stack.append(Vector2(maze_stack.back().x + 1, maze_stack.back().y + 0))
			2:
				maze[maze_offset(0, 1)].PATH_N = 1
				maze[maze_offset(0, 0)].PATH_S = 1
				maze_stack.append(Vector2(maze_stack.back().x + 0, maze_stack.back().y + 1))
			3:
				maze[maze_offset(-1, 0)].PATH_E = 1
				maze[maze_offset(0, 0)].PATH_W = 1
				maze_stack.append(Vector2(maze_stack.back().x - 1, maze_stack.back().y + 0))

		maze[maze_offset(0, 0)].VISITED = 1
		visited_cells += 1
	else:
		maze_stack.pop_back()
