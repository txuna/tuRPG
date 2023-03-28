extends Control

@onready var ProgressControl = $ProgressConrol
@onready var ResultControl = $ResultControl

# Called when the node enters the scene tree for the first time.
func _ready():
	ProgressControl.visible = false 
	ResultControl.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func enable_combat():
	ProgressControl.visible = true
	ResultControl.visible = false
	

func enable_result():
	ProgressControl.visible = false 
	ResultControl.visible = true
