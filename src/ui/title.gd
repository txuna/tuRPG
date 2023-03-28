extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_keep_start_btn_pressed():
	pass # Replace with function body.


func _on_new_start_btn_pressed():
	get_tree().change_scene_to_file("res://src/main/main_view.tscn")
