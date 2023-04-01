extends Node

signal set_hp_event
signal set_exp_event
signal set_level_event
signal set_coin_event

var PHYSICAL = 1 
var MAGIC = 2
	
const MAX_INVENTORY = 10

# 플레이어가 선택한 템을 여기로 인벤토리에서 옮기기 
var player_equipment = {
	Equipment.WEAPON : {
			"prototype_id" : 0, 
			# 추가 능력치
			"additional_state" : {
				"damage" : 10,
			}
	},
	Equipment.HAT : {
		
	}, 
	Equipment.SHIRT : {
		
	}, 
	Equipment.PANTS : {
		
	}, 
	Equipment.SHOES : {
		
	}, 
	Equipment.EARRING : {
		
	},
	Equipment.RING : {
		
	},
	Equipment.BELT : {
		
	},
	Equipment.CLOAK : {
		
	}
}

var inventory = {
	"equipment" : [
		{
			"prototype_id" : 100, 
			# 추가 능력치
			"additional_state" : {
				"damage" : 10,
				"armor" : 5,
				"critical_damage" : 7,
				"critical_percent" : 7,
				"max_hp" : 100
			}
		},
		{
			"prototype_id" : 1100, 
			"additional_state" : {
				
			}
		}
	], 
	# 장비아이템이 아닌경우 additional_state이 없다
	"consumption" : [
		{
			"prototype_id" : 1800, 
			"count" : 1
		}
	], 
	"etc" : [
		
	]
}

# 최종 스탯
# 기본스탯 + 무기 스탯 
var state = {
	"current_hp" : 100, 					# 현재 체력
	"max_exp" : 10,							# 최대 경험치
	"current_exp" : 3, 						# 현재 경험치 
	"level" : 1,							# 현재 레벨,
	"current_region_id" : 0,				# 플레이어 현재 위치 
	"damage_type" : PHYSICAL,				# 데미지 타입
	"name" : "player", 
	"coin" : 10,
}

# 기본 스탯(플레이어가 투자 가능) + 물약 
var basic_state = {
	"damage" : 10,							# 공격력(마력) 
	"critical_percent" : 10.0,				# 크리티컬 확률 
	"critical_damage" : 30.0,				# 크리티컬 데미지
	"armor" : 10.0,							# 방어력
	"magic_resistance" : 10, 				# 마법저항력
	"avoidance_rate" : 10.0, 				# 회피율
	"speed" : 10.0, 						# 스피드 
	"final_damage" : 15.0, 					# 최종데미지 
	"armor_penetration" : 10.0, 			# 방관
	"magic_resistance_penetration" : 10.0,	# 마관
	"max_hp" : 100,							# 최대 체력 
}

func _ready():
	calculate_state_from_equipment()
	
# 착용한 장비를 기반으로 스탯 재 설정
func calculate_state_from_equipment():
	for state_name in basic_state:
		state[state_name] = basic_state[state_name] + get_equipment_value(state_name)
			

# 착용한 장비의 방어력만 가지고옴
func get_equipment_value(_type):
	var value = 0
	for key in player_equipment:
		var equipment = player_equipment[key]
		# 해당 장비 미착용
		if equipment.is_empty():
			continue 
		# 착용중이라면 해당 아이템의 prototype_id확인 후 additional_state 확인
		var id = equipment.prototype_id 
		var prototype = Equipment.prototype[id]
		# 해당 옵션이 없다면 그래도 추가옵션은 봐야 됨
		if prototype.state.has(_type):
			value += prototype.state[_type] 
		
		# 추가 능력치 존재하지 않는다면 
		if equipment.additional_state.is_empty():
			continue 
			
		# 추가 능력치 항목은 존재하나 해당 능력치가 아닌경우 
		if equipment.additional_state.has(_type):
			value += equipment.additional_state[_type]
		
		# 무기라면 무기상수 고려
		if prototype.info.section == Equipment.WEAPON and _type == "damage":
			value = int(value * Equipment.WEAPON_VALUE[prototype.info.field].value)
		
	return value 


func change_region(region_id):
	state.current_region_id = region_id

# 검사 로직은 player단에서
func change_hp(value, notify=true):
	if state.current_hp + value >= state.max_hp:
		state.current_hp = state.max_hp 
	
	elif state.current_hp + value <= 0:
		state.current_hp = 0 
	
	else:	
		state.current_hp += value 
	
	if notify:
		emit_signal("set_hp_event")
	return 
	
	
func init_hud():
	emit_signal("set_exp_event")	
	emit_signal("set_hp_event")
	emit_signal("set_level_event")	
	emit_signal("set_coin_event")
	
func change_exp(value):
	pass

# 전투 종료 팝업이 끝나면 체력바 HUD표시가능하게 false설정
func get_damage(damage):
	change_hp(-damage, false)


# 인벤토리 아이템 사용 
#- 소비 아이템의 경우 갯수를 줄이고
#- 장비 아이템의 경우 기존 착용 장비 확인
func use_item(item):
	var prototype = Equipment.prototype[item.prototype_id]
	if prototype.info.inventory_type == Equipment.CONSUMPTION:
		if item.count < 1:
			return
		use_consumption(item, prototype)
		
	elif prototype.info.inventory_type == Equipment.EQUIPMENT:
		wear_equipment(item, prototype)
	return 
	
	
func use_consumption(item, prototype):
	for state_name in prototype.state:
		if state_name == "current_hp":
			# 이미 체력이 가득찬 상태일 경우
			if state.current_hp == state.max_hp:
				get_node("/root/MainView").open_alert_popup(Global.ALREADY_FULL_HP)
				return 
				
			change_hp(prototype.state[state_name])
		else:
			basic_state[state_name] += prototype.state[state_name]
	
	item.count-=1
	# 해당 아이템 삭제
	if item.count <= 0:
		inventory.consumption.erase(item)
	
	# 추후 상태창도 업데이트 
	var inventory_node = get_node("/root/MainView/InventoryPopup") 
	inventory_node._on_update_inventory()
		

# 기존에 착용중이던 장비 확인 및 백업 
# 체력바 같은 경우를 위해 hud_init + inventory update 
# 최대 최력이 현재체력보다 작아질 경우 현재 체력 체력체력으로 설정 
# 착용한 무기의 속성 부여
func wear_equipment(item, prototype):
	var section = prototype.info.section 
	var origin_equipment = null 
	# 현재 착용중이라면 
	if not player_equipment[section].is_empty():
		# 기존 장비 백업
		origin_equipment = player_equipment[section]
	
	# 새로운 장비 착용
	player_equipment[section] = item 
	# 착용하려는 아이템 인벤토리에서 삭제 
	inventory.equipment.erase(item)
	# 기존장비 존재한다면 인벤토리에 넣기 
	if origin_equipment != null:
		inventory.equipment.append(origin_equipment)

	# 착용한 상태에서 스탯 재설정
	calculate_state_from_equipment()
	# 만약 착용한 장비가 무기라면 무기의 데미지 타입 설정 
	if prototype.info.section == Equipment.WEAPON:
		state.damage_type = prototype.info.type

	# 최대체력이 현재 체력보다 작다면 현재체력을 최대체력으로 설정 
	if state.current_hp > state.max_hp:
		state.current_hp = state.max_hp
		
	# hud와 인벤토리 업데이트 - 추후 상태창도 
	var inventory_node = get_node("/root/MainView/InventoryPopup") 
	inventory_node._on_update_inventory()
	init_hud()

# 인벤토리 크기 확인
func take_off_equipment(item):
	# 맥시멈 인벤토리 사이즈라면
	if inventory.equipment.size() >= MAX_INVENTORY:
		get_node("/root/MainView").open_alert_popup(Global.NOT_ENOUGH_INVENTORY)
		return 
		
	var id = item.prototype_id 
	var prototype = Equipment.prototype[id] 
	var section = prototype.info.section 
	
	player_equipment[section] = {} 
	calculate_state_from_equipment()
	inventory.equipment.append(item)
	
	if state.current_hp > state.max_hp:
		state.current_hp = state.max_hp
		
	# 무기가 없는 상태는 물리타입 
	state.damage_type = PHYSICAL
	var inventory_node = get_node("/root/MainView/InventoryPopup") 
	inventory_node._on_update_inventory()
	init_hud()


func get_coin(value):
	state.coin += value 
	emit_signal("set_coin_event")


# 경험치를 많이 받아도 다음레벨의 -1 까지획득 가능 
# 레벨업시 경험치 증가률은 1.5 
# 레벨업시 스탯포인트 3개 부여
func get_exp(value):
	# 레벨 경험치를 초과할 경우 
	if state.current_exp + value >= state.max_exp:
		state.level += 1
		# 경험치 차액만큼 제거 및 상한선 설정 
		value = value - (state.max_exp - state.current_exp)
		state.current_exp = 0 
		state.max_exp = int(state.max_exp * 1.5)
		# 다음 레벨업시에도 크다면 -1만큼 삭제 
		if state.current_exp + value >= state.max_exp:
			state.current_exp = state.max_exp - 1
		else:
			state.current_exp += value
	else:
		state.current_exp += value
		
	emit_signal("set_exp_event")
	emit_signal("set_level_event")


func check_already_has_item(id, inventory_type):
	for item in inventory[inventory_type]:
		if item.prototype_id == id:
			return true
			
	return false
	

func get_item(id, inventory_type):
	# 인벤토리 용량 초과
	if inventory[inventory_type].size() >= MAX_INVENTORY:
		return -1

	if inventory_type == "equipment":
		var item = {
			"prototype_id" : id, 
			"additional_state" : {
				
			}
		}
		inventory[inventory_type].append(item)
		
	# 이미 해당 아이템을 가지고 있다면(소비, 기타)
	elif inventory_type in ["consumption", "etc"]:
		if check_already_has_item(id, inventory_type):
			var index = get_inventory_item_index_from_id(id, inventory_type)
			inventory[inventory_type][index].count += 1
		else:
			inventory[inventory_type].append({
				"prototype_id" : id,
				"count" : 1
			})
	# 인벤토리 창 업데이트
	var inventory_node = get_node("/root/MainView/InventoryPopup") 
	inventory_node._on_update_inventory()
	return id


func get_inventory_item_index_from_id(id, inventory_type):
	var index = 0 
	for item in inventory[inventory_type]:
		if item.prototype_id == id:
			return index 
		index+=1 
	
	return -1 



