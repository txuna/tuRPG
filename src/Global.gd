extends Node

var PHYSICAL = 1 
var MAGIC = 2

var MONSTER = 1
var VILLAGE = 2
var PLAYER = 3

var DEFENSE_CONSTANT = 100

const NOT_ENOUGH_INVENTORY = 1
const ALREADY_FULL_HP = 2
const NOT_ENOUGH_COIN = 3

const SHOPKEEPER = 1


const comment_alert = {
	NOT_ENOUGH_INVENTORY : "인벤토리 크키가 부족하여 아이템을 벗을 수 없습니다.",
	ALREADY_FULL_HP : "이미 체력이 가득 찬 상태입니다. 물약을 사용할 필요가 없습니다.",
	NOT_ENOUGH_COIN : "돈이 부족합니다."
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
		"id" : 0, 
		"name" : "페리마을", 
		"scene" : load("res://src/ui/village/perry_village_popup.tscn"),
		"npc" : {
			0 : {
				"name" : "페리마을 상점",
				"type" : SHOPKEEPER, 
				"product" : [0, 1,2,3,4,5,6,7,8,9,10, 1800, 100, 101, 102, 103, 104, 105, 106, 1000, 1001, 1100, 1101, 1200, 1300, 1401, 1501]
			},
		}
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
		"connected" 	: [1]
	},
	1 : {
		"id"			: 1,
		"region_name" 	: "페리호수1",
		"image" 		: load("res://Assets/monster/mushroom_fill.png"), 
		"type"			: MONSTER,
		"type_id"		: 0,		#몬스터 ID
		"connected" 	: [0, 2, 3]
	}, 
	2 : {
		"id"			: 2,
		"region_name" 	: "페리호수2",
		"image" 		: load("res://Assets/monster/mushroom_fill.png"), 
		"type"			: MONSTER,
		"type_id"		: 0,		#몬스터 ID
		"connected" 	: [1, 6]
	}, 
	3 : {
		"id"			: 3,
		"region_name" 	: "페리들판1",
		"image" 		: load("res://Assets/monster/mushroom_fill.png"), 
		"type"			: MONSTER,
		"type_id"		: 0,		#몬스터 ID
		"connected" 	: [1, 4, 11]
	}, 
	4 : {
		"id"			: 4,
		"region_name" 	: "페리들판2",
		"image" 		: load("res://Assets/monster/mushroom_fill.png"), 
		"type"			: MONSTER,
		"type_id"		: 0,		#몬스터 ID
		"connected" 	: [3, 5]
	}, 
	5 : {
		"id"			: 5,
		"region_name" 	: "페리들판3",
		"image" 		: load("res://Assets/monster/mushroom_fill.png"), 
		"type"			: MONSTER,
		"type_id"		: 0,		#몬스터 ID
		"connected" 	: [4]
	}, 
	6 : {
		"id"			: 6,
		"region_name" 	: "페리평원1",
		"image" 		: load("res://Assets/monster/mushroom_fill.png"), 
		"type"			: MONSTER,
		"type_id"		: 0,		#몬스터 ID
		"connected" 	: [2, 7]
	}, 
	7 : {
		"id"			: 7,
		"region_name" 	: "페리평원2",
		"image" 		: load("res://Assets/monster/mushroom_fill.png"), 
		"type"			: MONSTER,
		"type_id"		: 0,		#몬스터 ID
		"connected" 	: [6, 8]
	}, 
	8 : {
		"id"			: 8,
		"region_name" 	: "페리산 언덕아래",
		"image" 		: load("res://Assets/monster/mushroom_fill.png"), 
		"type"			: MONSTER,
		"type_id"		: 0,		#몬스터 ID
		"connected" 	: [7, 9]
	}, 
	9 : {
		"id"			: 9,
		"region_name" 	: "페리산 깊은 골",
		"image" 		: load("res://Assets/monster/mushroom_fill.png"), 
		"type"			: MONSTER,
		"type_id"		: 0,		#몬스터 ID
		"connected" 	: [8, 10]
	},
	10 : {
		"id"			: 10,
		"region_name" 	: "페리산 고원",
		"image" 		: load("res://Assets/monster/mushroom_fill.png"), 
		"type"			: MONSTER,
		"type_id"		: 0,	#몬스터 ID
		"connected" 	: [9]
	}, 
	11 : {
		"id"			: 11,
		"region_name" 	: "숲의 시작",
		"image" 		: load("res://Assets/monster/mushroom_fill.png"), 
		"type"			: MONSTER,
		"type_id"		: 0,		#몬스터 ID
		"connected" 	: [3, 12]
	}, 
	12 : {
		"id"			: 12,
		"region_name" 	: "울창한 숲",
		"image" 		: load("res://Assets/monster/mushroom_fill.png"), 
		"type"			: MONSTER,
		"type_id"		: 0,		#몬스터 ID
		"connected" 	: [11, 13]
	}, 
	13 : {
		"id"			: 13,
		"region_name" 	: "솦의 갈림길",
		"image" 		: load("res://Assets/monster/mushroom_fill.png"), 
		"type"			: MONSTER,
		"type_id"		: 0,		#몬스터 ID
		"connected" 	: [12, 14, 16]
	}, 
	14 : {
		"id"			: 14,
		"region_name" 	: "깊은 숲1",
		"image" 		: load("res://Assets/monster/mushroom_fill.png"), 
		"type"			: MONSTER,
		"type_id"		: 0,		#몬스터 ID
		"connected" 	: [13, 15]
	}, 
	15 : {
		"id"			: 15,
		"region_name" 	: "깊은 숲2",
		"image" 		: load("res://Assets/monster/mushroom_fill.png"), 
		"type"			: MONSTER,
		"type_id"		: 0,		#몬스터 ID
		"connected" 	: [14]
	}, 
	16 : {
		"id"			: 16,
		"region_name" 	: "고요한 숲",
		"image" 		: load("res://Assets/monster/mushroom_fill.png"), 
		"type"			: MONSTER,
		"type_id"		: 0,		#몬스터 ID
		"connected" 	: [13]
	}, 
}


func get_damage(monster, damage):
	if monster.current_hp - damage <= 0:
		monster.current_hp = 0 
	else:
		monster.current_hp -= damage 
	return 

