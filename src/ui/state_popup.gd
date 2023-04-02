extends CanvasLayer

@onready var state_list_container = $Control/TextureRect/Control/ScrollContainer/HBoxContainer2/StateContainer
@onready var info_list_container = $Control/TextureRect/Control/ScrollContainer/HBoxContainer2/InfoContainer
@onready var level_label = $Control/TextureRect/Control/ScrollContainer/HBoxContainer2/InfoContainer/LevelLabel
@onready var current_exp_label = $Control/TextureRect/Control/ScrollContainer/HBoxContainer2/InfoContainer/CurrentExpLabel
@onready var max_exp_label = $Control/TextureRect/Control/ScrollContainer/HBoxContainer2/InfoContainer/MaxExpLabel
@onready var coin_label = $Control/TextureRect/Control/ScrollContainer/HBoxContainer2/InfoContainer/CoinLabel
@onready var state_point_label = $Control/TextureRect/Control/ScrollContainer/HBoxContainer2/InfoContainer/StatePointLabel
@onready var damage_type_label = $Control/TextureRect/Control/ScrollContainer/HBoxContainer2/InfoContainer/DamageTypeLabel
@onready var current_region_label = $Control/TextureRect/Control/ScrollContainer/HBoxContainer2/InfoContainer/CurrentRegionLabel
@onready var name_label = $Control/TextureRect/Control/ScrollContainer/HBoxContainer2/InfoContainer/NameLabel

@onready var equipment_background = $Control/TextureRect/EquipmentBackground/GridContainer

"""
const WEAPON = 1
const HAT = 2 
const SHIRT = 3 
const PANTS = 4
const SHOES = 5
const EARRING = 6
const RING = 7
const BELT = 8
const CLOAK = 9
"""

const state_name_list = ["damage", "critical_percent", "critical_damage", "armor", "magic_resistance", 
"avoidance_rate", "speed", "final_damage", "armor_penetration", "magic_resistance_penetration", "max_hp", "current_hp"]

const equipment_name_list = [Equipment.WEAPON, Equipment.HAT, Equipment.SHIRT, Equipment.PANTS, Equipment.SHOES,
Equipment.EARRING, Equipment.RING, Equipment.BELT, Equipment.CLOAK]

# Called when the node enters the scene tree for the first time.
func _ready():
	init_state()
	_on_open_state()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_texture_button_pressed():
	visible = false


func _on_toggle_state():
	if visible:
		visible = false  
	else:
		_on_open_state()
	return 
	
	
func init_state():
	var player_state = PlayerState.state
	var index = 0
	for state_container in state_list_container.get_children():
		var state_label = state_container.get_node("StateEleHbox/StateNameLabel") 
		var state_btn = state_container.get_node("UpEleHbox/StateUpBtn") 
		
		# 시그널링만 생성
		state_btn.pressed.connect(_on_pressed_upgrade_state_btn.bind(state_name_list[index]))
		index+=1 
		

func _on_pressed_upgrade_state_btn(state_name):
	print(state_name)


# 버튼 활성화 유무 확인
func _on_open_state():
	visible = true
	var player_state = PlayerState.state
	var index = 0
	
	# 스탯 컨테이너 업데이트
	for state_container in state_list_container.get_children():
		var state_label = state_container.get_node("StateEleHbox/StateNameLabel") 
		var state_btn = state_container.get_node("UpEleHbox/StateUpBtn") 
		
		state_label.text = "{state_name} : {value}".format({
			"state_name" : PlayerState.comment_state_string[state_name_list[index]],
			"value" : str(player_state[state_name_list[index]])
		})
		index += 1
		# 업그레이드 포인트가 없다면 비활성화 
		if player_state.upgrade_point > 0:
			state_btn.disabled = false
		else:
			state_btn.disabled = false
			
		
	# 인포컨테이트 설정 
	level_label.text = "레벨 : {value}".format({"value" : str(player_state.level)})
	current_exp_label.text = "현재 경험치 : {value}".format({"value" : str(player_state.current_exp)})
	max_exp_label.text = "최대 경험치 : {value}".format({"value" : str(player_state.max_exp)})
	coin_label.text = "코인 : {value}".format({"value" : str(player_state.coin)})
	state_point_label.text = "스탯 포인트 : {value}".format({"value" : str(player_state.upgrade_point)})
	damage_type_label.text = "현재 경험치 : {value}".format({"value" : Equipment.comment_damage_type_string[player_state.damage_type]})
	current_region_label.text = "현재지역 : {value}".format({"value" : Global.region_info[player_state.current_region_id].region_name})
	name_label.text = "이름 : {value}".format({"value" : player_state.name})

	# 장비 현황 업데이트 - 시그널 연결 유무 확인
	var item_index = 0
	for node in equipment_background.get_children():
		var texture_node = node.get_node("TextureRect")
		var item = PlayerState.player_equipment[equipment_name_list[item_index]]
		item_index += 1
		texture_node.texture = null
		# 이미 gui에 연결되어 있다면 해제
		if texture_node.gui_input.is_connected(_on_open_detail):
			texture_node.gui_input.disconnect(_on_open_detail)
		# 아이템이 없는경우 
		if item.is_empty():
			continue 
		var prototype = Equipment.prototype[item.prototype_id]
		texture_node.texture = ImageTexture.create_from_image(prototype.info.image)
		texture_node.gui_input.connect(_on_open_detail.bind(item))

	
func _on_update_state():
	if visible:
		_on_open_state()
	

func _on_open_detail(event: InputEvent, item):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and not event.pressed:		
			var detail_popup = load("res://src/ui/detail_popup.tscn").instantiate() 
			get_parent().add_child(detail_popup)
			detail_popup._on_open_detail_popup(item)
		# item use !
		elif event.double_click:
			# 아이템 타입이 기타, 소비이면 패스 
			var item_type = Equipment.prototype[item.prototype_id].info.inventory_type
			if item_type in [Equipment.ETC, Equipment.CONSUMPTION]:
				return 
			PlayerState.take_off_equipment(item)
			
	return 
	
	
	
	
	
	
	
	
	
	
	
	
	
	
