extends Node

signal set_hp_event
signal set_exp_event
signal set_level_event
signal set_coin_event

var PHYSICAL = 1 
var MAGIC = 2
	

# 플레이어가 선택한 템을 여기로 인벤토리에서 옮기기 
var player_equipment = {
	Equipment.WEAPON : {
		
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
				"critical_percent" : 7
			}
		}
	], 
	# 장비아이템이 아닌경우 additional_state이 없다
	"consumption" : [
		{
			"prototype_id" : 1000, 
			"count" : 1
		}
	], 
	"etc" : [
		
	]
}

# 장비 스탯은 어떻게? + 플러스 값? 
# 기본 스탯 + equipment.armor.sum_damage 프로토타입 느낌으로 ? 
var state = {}

func _ready():
	state = {
		"damage" : 10 + get_equipment_value("damage"), 						# 공격력(마력) 
		"critical_percent" : 10.0 + get_equipment_value("critical_percent"),# 크리티컬 확률 
		"critical_damage" : 30.0 + get_equipment_value("critical_damage"),	# 크리티컬 데미지
		"armor" : 10.0 + get_equipment_value("armor"),						# 방어력
		"magic_resistance" : 10 + get_equipment_value("magic_resistance"), 	# 마법저항력
		"avoidance_rate" : 10.0 + get_equipment_value("avoidance_rate"), 	# 회피율
		"speed" : 10.0 + get_equipment_value("speed"), 						# 스피드 
		"final_damage" : 15.0 + get_equipment_value("final_damage"), 		# 최종데미지 
		"armor_penetration" : 10.0 + get_equipment_value("armor_penetration"), 						# 방관
		"magic_resistance_penetration" : 10.0 + get_equipment_value("magic_resistance_penetration"), # 마관
		"max_hp" : 100 + get_equipment_value("max_hp"),	# 최대 체력 
		"current_hp" : 100, 							# 현재 체력
		"max_exp" : 10,									# 최대 경험치
		"current_exp" : 3, 								# 현재 경험치 
		"level" : 1,									# 현재 레벨,
		"current_region_id" : 0,						# 플레이어 현재 위치 
		"damage_type" : PHYSICAL,						# 데미지 타입
		"name" : "player", 
		"coin" : 10,
	}

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
		pass
		
	return 
	
	
func use_consumption(item, prototype):
	for state_name in prototype.state:
		if state_name == "current_hp":
			change_hp(prototype.state[state_name])
		else:
			state[state_name] += prototype.state[state_name]
	
	item.count-=1
	# 해당 아이템 삭제
	if item.count <= 0:
		inventory.consumption.erase(item)
	
	var inventory_node = get_node("/root/MainView/InventoryPopup") 
	inventory_node._on_update_inventory()
		









