extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var dir_y = 0
var dir_x = 0
const speed = 75

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_controls()

func get_controls():
	dir_y = 0
	dir_x = 0

	if Input.is_action_pressed("ui_up"):
		dir_y = -speed
	if Input.is_action_pressed("ui_down"):
		dir_y = speed
	if Input.is_action_pressed("ui_right"):
		dir_x = speed
	if Input.is_action_pressed("ui_left"):
		dir_x = -speed

func _physics_process(delta):
	var spiidi = Vector2(dir_x, dir_y)
	move_and_slide(spiidi)
	
