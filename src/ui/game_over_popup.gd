extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# 기존 이어하기 데이터 파괴
func _on_restart_btn_pressed():
	queue_free()
	get_tree().change_scene_to_file("res://src/ui/title.tscn")
