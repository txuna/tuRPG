extends Control

@onready var regions = $ColorRect/RegionControl
@onready var draw_control = $ColorRect/DrawControl

var is_dragging = false 
var previous_mouse_position = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	gui_input()


func gui_input():
	if Input.is_action_just_pressed("pressed"):
		get_viewport().set_input_as_handled()
		previous_mouse_position = get_viewport().get_mouse_position()
		is_dragging = true


func _input(event):
	if not is_dragging:
		return 
	
	if Input.is_action_just_released("pressed"):
		previous_mouse_position = Vector2()
		is_dragging = false 

	# move limit = 0~1920, 0~1080 
	if is_dragging and event is InputEventMouseMotion:
		global_position += event.position - previous_mouse_position
		
		if global_position.x < -2080:
			global_position.x = -2080 
		if global_position.x > 0:
			global_position.x = 0
		if global_position.y < -1090:
			global_position.y = -1090
		if global_position.y > 0:
			global_position.y = 0

		previous_mouse_position = event.position



		


