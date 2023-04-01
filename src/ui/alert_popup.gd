extends CanvasLayer

@onready var content_label = $Control/TextureRect/ContentLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_texture_button_pressed():
	queue_free()


func set_content_text(_text: String):
	content_label.text = _text
