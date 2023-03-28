extends Node2D


var speed = 300

var path_fallow = null 
# Called when the node enters the scene tree for the first time.
func _ready():
	path_fallow = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if path_fallow == null:
		return 

	path_fallow.set_progress(path_fallow.get_progress() + speed * delta)
	
