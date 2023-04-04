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
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_close_btn_pressed():
	queue_free()
	#visible = false


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
		node.get_node("TextureRect").get_node("CountLabel").text = ""
		# 시그널 연결 끊기 
		if node.get_node("TextureRect").gui_input.is_connected(_on_open_detail):
			node.get_node("TextureRect").gui_input.disconnect(_on_open_detail)


func _on_update_inventory():
	_on_open_inventory()


# 소비아이템이나 기타아이템의 경우 count도 추가
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
		node.texture = image#ImageTexture.create_from_image(image)
		# 소비아이템이거나 기타아이템의 경우 갯수 표시
		if not inventory_type == Equipment.EQUIPMENT:
			node.get_node("CountLabel").text = str(inventory_content[index].count)
		# 시그널 연결
		node.gui_input.connect(_on_open_detail.bind(item))
	

func _on_open_detail(event: InputEvent, item):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and not event.pressed:		
			var detail_popup = load("res://src/ui/detail_popup.tscn").instantiate() 
			get_parent().add_child(detail_popup)
			detail_popup._on_open_detail_popup(item)
		# item use !
		elif event.double_click:
			# 아이템 타입이 기타 아이템이라면 패스
			var item_type = Equipment.prototype[item.prototype_id].info.inventory_type
			if item_type == Equipment.ETC:
				return 
			PlayerState.use_item(item)
	return 






