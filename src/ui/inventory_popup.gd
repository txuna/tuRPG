extends CanvasLayer


var inventory_type = Equipment.EQUIPMENT
@onready var inventory_container = $TextureRect/ScrollContainer/GridContainer

var string_type = {
	Equipment.EQUIPMENT : "equipment", 
	Equipment.CONSUMPTION : "consumption", 
	Equipment.ETC : "etc"
}

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_close_btn_pressed():
	visible = false


func _on_equipment_btn_pressed():
	inventory_type = Equipment.EQUIPMENT
	_on_open_inventory()


func _on_consumption_btn_pressed():
	inventory_type = Equipment.CONSUMPTION
	_on_open_inventory()


func _on_etc_btn_pressed():
	inventory_type = Equipment.ETC
	_on_open_inventory()


func init_inventory():
	for node in inventory_container.get_children():
		node.get_node("TextureRect").texture = null
		# 시그널 연결 끊기 
		if node.get_node("TextureRect").gui_input.is_connected(_on_open_detail):
			node.get_node("TextureRect").gui_input.disconnect(_on_open_detail)



func _on_open_inventory():
	visible = true
	init_inventory()
	var type = string_type[inventory_type]
	var inventory_content = PlayerState.inventory[type]
	var texture_list = inventory_container.get_children()
	for index in len(inventory_content):
		var item = inventory_content[index]
		var prototype_id = item.prototype_id
		var image = Equipment.prototype[prototype_id].info.image
		var node = texture_list[index].get_node("TextureRect")
		node.texture = ImageTexture.create_from_image(image)
		# 시그널 연결
		node.gui_input.connect(_on_open_detail.bind(item))
	

func _on_open_detail(event: InputEvent, item):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and not event.pressed:		
			var detail_popup = load("res://src/ui/detail_popup.tscn").instantiate() 
			get_parent().add_child(detail_popup)
			detail_popup._on_open_detail_popup(item)


func _on_toggle_inventory():
	if visible:
		visible = false  
	else:
		_on_open_inventory()
	return 







