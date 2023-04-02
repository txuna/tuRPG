extends CanvasLayer

@onready var spoil_container = $Control/TextureRect/ScrollContainer/VBoxContainer
@onready var coin_label = $Control/TextureRect/CoinLabel
@onready var exp_label = $Control/TextureRect/ExpLabel
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func set_spoils(coin, exp, item_list):
	coin_label.text = "Coin : {coin}$".format({
		"coin" : str(coin)
	})
	exp_label.text = "Exp : {exp}".format({
		"exp" : str(exp)
	})
	for id in item_list:
		var prototype = Equipment.prototype[id]
		var hbox = HBoxContainer.new() 
		var label = Label.new() 
		var texture = TextureRect.new() 
		label.add_theme_color_override("font_color", Color.BLACK)
		label.add_theme_font_override("font", load("res://Assets/fonts/NanumBarunpenB.ttf"))
		label.add_theme_font_size_override("font_size", 16)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		hbox.alignment = BoxContainer.ALIGNMENT_CENTER
		hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		label.text = prototype.info.name 
		texture.texture = prototype.info.image#ImageTexture.create_from_image(prototype.info.image)
		
		hbox.add_child(texture)
		hbox.add_child(label)
		spoil_container.add_child(hbox)


func _on_texture_button_pressed():
	queue_free()
