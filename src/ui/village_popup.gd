extends CanvasLayer


var village = {}
@onready var title_label = $Control/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func init(_id):
	village = Global.village_info[_id]
	title_label.text = village.name


func _on_exit_btn_pressed():
	queue_free()
