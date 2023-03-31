extends Node2D


@export var speed = 300 
@export var region_id = 0

var path_fallow = null 
# Called when the node enters the scene tree for the first time.
func _ready():
	region_id = PlayerState.state.current_region_id
	#path_fallow = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#if path_fallow == null:
	#	return 
	#
	#path_fallow.set_progress(path_fallow.get_progress() + speed * delta)
	

# player의 global_position 변경
func change_region(id):
	region_id = id
