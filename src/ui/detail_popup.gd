extends CanvasLayer

@onready var comment_label = $TextureRect/CommentLabel
@onready var section_label = $TextureRect/SectionLabel
@onready var state_control = $TextureRect/StateControl 
@onready var item_texture = $TextureRect/TextureRect/TextureRect2
@onready var item_name_label = $TextureRect/ItemNameLabel
@onready var state_container = $TextureRect/ScrollContainer/VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_open_detail_popup(item):
	var item_prototype = Equipment.prototype[item.prototype_id]
	var additional_state = {}
	# 장비 아이템의 경우 additional_state까지 고려 -> 한손 검(물리), 상의 등등 
	if item_prototype.info.inventory_type == Equipment.EQUIPMENT:
		if item_prototype.info.section == Equipment.WEAPON:
			section_label.text = "아이템 분류 : {type}({damage_type})".format({
				"type" : Equipment.comment_type_string[item_prototype.info.field], 
				"damage_type" : Equipment.comment_damage_type_string[item_prototype.info.type]
			})
		else:
			section_label.text = "아이템 분류 : {type}".format({
				"type" : Equipment.comment_type_string[item_prototype.info.section]
			})
		
	
	elif item_prototype.info.inventory_type == Equipment.CONSUMPTION:
		section_label.text = "소비아이템"
		
	elif item_prototype.info.inventory_type == Equipment.ETC:
		section_label.text = "기타아이템"
	
	item_name_label.text = item_prototype.info.name
	comment_label.text = item_prototype.info.comment 
	item_texture.texture = item_prototype.info.image# ImageTexture.create_from_image(item_prototype.info.image)

	# 추옵의 경우 색깔을 더한다. 5 (+3) 이런식- 프로토타입에는 없지만 추가능력치에는 있을경우도 고려해야함
	
	for state_name in item_prototype.state:
		var label = Label.new() 
		label.add_theme_color_override("font_color", Color.BLACK)
		label.add_theme_font_override("font", load("res://Assets/fonts/NanumBarunpenB.ttf"))
		label.add_theme_font_size_override("font_size", 14)
		var value = item_prototype.state[state_name]
	
		# 장비 아이템이 아닌경우
		if not item_prototype.info.inventory_type == Equipment.EQUIPMENT:
			label.text = "{state_name} : {value}".format({
				"state_name" : Global.comment_state_string[state_name], 
				"value" : value
			})
	
		# 장비 아이템인 경우
		else:
			# 해당 스탯에 대한 추가 능력치가 없다면
			if not item.additional_state.has(state_name):
				label.text = "{state_name} : {value}".format({
				"state_name" : Global.comment_state_string[state_name], 
				"value" : value
			})
			else:
				var plus_value = item.additional_state[state_name]
				label.text = "{state_name} : {value} + ({plus_value})".format({
					"state_name" : Global.comment_state_string[state_name], 
					"value" : str(value),
					"plus_value" : str(plus_value)
				})
		state_container.add_child(label)

	# 프로토타입 스탯에는 없지만 에디셔널에는 있는 경우 
	if not item_prototype.info.inventory_type == Equipment.EQUIPMENT:
		return 
		
	for state_name in item.additional_state:
		if item_prototype.state.has(state_name):
			continue 
		var label = Label.new() 
		label.add_theme_color_override("font_color", Color.BLACK)
		label.add_theme_font_override("font", load("res://Assets/fonts/NanumBarunpenB.ttf"))
		label.add_theme_font_size_override("font_size", 14)
		label.text = "{state_name} : 0 + ({value})".format({
			"state_name" :  Global.comment_state_string[state_name], 
			"value" : str(item.additional_state[state_name])
		})
		state_container.add_child(label)


func _on_exit_btn_pressed():
	queue_free()















