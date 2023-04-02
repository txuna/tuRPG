extends Node

var PHYSICAL = 1 
var MAGIC = 2

var MONSTER = 1
var VILLAGE = 2
var PLAYER = 3

var DEFENSE_CONSTANT = 100

const NOT_ENOUGH_INVENTORY = 1
const ALREADY_FULL_HP = 2

const comment_alert = {
	NOT_ENOUGH_INVENTORY : "인벤토리 크키가 부족하여 아이템을 벗을 수 없습니다.",
	ALREADY_FULL_HP : "이미 체력이 가득 찬 상태입니다. 물약을 사용할 필요가 없습니다."
}

const comment_state_string = {
	"damage" : "공격력", 
	"critical_percent" : "크리티컬 확률", 
	"critical_damage" : "크리티컬 데미지", 
	"armor" : "방어력", 
	"magic_resistance" : "마법 저항력", 
	"avoidance_rate" : "회피율", 
	"speed" : "스피드", 
	"final_damage" : "최종 데미지", 
	"armor_penetration" : "물리 관통력", 
	"magic_resistance_penetration" : "마법 관통력", 
	"max_hp" : "최대 체력", 
	"current_hp" : "체력 회복"
}

var village_info = {
	0 : {
		
	}
}
# 장비아이템의 경우 additional_state 랜덤으로 결정 
# 몬스터의 레벨에 따라 1 ~ 5티어 추옵에서 확률 결정 
# item은 얻을 확률 -> 0.00 ~ 100.00
var monster_spoil = {
	0 : {
		"exp" : 13, 
		"coin" : 15, 
		"item" : {
			0 : 10.00, 	# 녹슨 검 
			1800 : 10.00, # 체력회복 포션(50)
			100 : 10.00, 
			1100 : 10.00
		}
	}
}
# id, level, name,
var monster_info = {
	0 : {
		"id" : 0, 
		"name" : "버섯 킹",
		"damage" : 3.0, 							# 공격력(마력) 
		"critical_percent" : 10.0,				# 크리티컬 확률 
		"critical_damage" : 30.0, 				# 크리티컬 데미지
		"armor" : 23.0,							# 방어력
		"magic_resistance" : 43.0, 				# 마법저항력
		"avoidance_rate" : 10.0, 				# 회피율
		"speed" : 10.0, 							# 스피드 
		"final_damage" : 10.0, 					# 최종데미지 
		"armor_penetration" : 10.0, 				# 방관
		"magic_resistance_penetration" : 10.0, 	# 마관
		"current_hp" : 50, 						# 현재 체력
		"level" : 1,							# 현재 레벨,
		"damage_type" : PHYSICAL,				# 데미지 타입 
	}
}


var region_info = {
	0 : {
		"id"			: 0,
		"region_name" 	: "페리마을",
		"image" 		: load("res://Assets/map/village.png"), 
		"type"			: VILLAGE,
		"type_id"		: 0,		
		"connected" 	: [1, 3]
	},
	1 : {
		"id"			: 1,
		"region_name" 	: "페리호수",
		"image" 		: load("res://Assets/monster/mushroom_fill.png"), 
		"type"			: MONSTER,
		"type_id"		: 0,		#몬스터 ID
		"connected" 	: [0, 2, 3]
	}, 
	2 : {
		"id"			: 2,
		"region_name" 	: "페리산 아래",
		"image" 		: load("res://Assets/monster/mushroom_fill.png"), 
		"type"			: MONSTER,
		"type_id"		: 0,
		"connected" 	: [1]
	},
	3 : {
		"id"			: 3,
		"region_name" 	: "페리평원",
		"image" 		: load("res://Assets/monster/mushroom_fill.png"), 
		"type"			: MONSTER,
		"type_id"		: 0,
		"connected" 	: [0, 1, 4]
	},
	4 : {
		"id"			: 4,
		"region_name" 	: "페리들판",
		"image" 		: load("res://Assets/monster/mushroom_fill.png"), 
		"type"			: MONSTER,
		"type_id"		: 0,
		"connected" 	: [3]
	}
}


func get_damage(monster, damage):
	if monster.current_hp - damage <= 0:
		monster.current_hp = 0 
	else:
		monster.current_hp -= damage 
	return 

