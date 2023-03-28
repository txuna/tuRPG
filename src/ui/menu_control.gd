extends CanvasLayer

signal toggle_inventory 
signal toggle_state 
signal toggle_quest



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_inventory_btn_pressed():
	emit_signal("toggle_inventory")


func _on_state_btn_pressed():
	emit_signal("toggle_state")


func _on_quest_btn_pressed():
	emit_signal("toggle_quest")














