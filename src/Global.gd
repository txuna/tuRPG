extends Node

var PHYSICAL = 1 
var MAGIC = 2

var MONSTER = 1
var VILLAGE = 2
var PLAYER = 3

var DEFENSE_CONSTANT = 100

var village_info = {
	0 : {
		
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
		"image" 		: Image.load_from_file("res://Assets/map/village.png"), 
		"type"			: VILLAGE,
		"type_id"		: 0,
		"connected" 	: [1, 3]
	},
	1 : {
		"id"			: 1,
		"region_name" 	: "페리호수",
		"image" 		: Image.load_from_file("res://Assets/monster/mushroom_fill.png"), 
		"type"			: MONSTER,
		"type_id"		: 0,
		"connected" 	: [0, 2, 3]
	}, 
	2 : {
		"id"			: 2,
		"region_name" 	: "페리산 아래",
		"image" 		: Image.load_from_file("res://Assets/monster/mushroom_fill.png"), 
		"type"			: MONSTER,
		"type_id"		: 0,
		"connected" 	: [1]
	},
	3 : {
		"id"			: 3,
		"region_name" 	: "페리평원",
		"image" 		: Image.load_from_file("res://Assets/monster/mushroom_fill.png"), 
		"type"			: MONSTER,
		"type_id"		: 0,
		"connected" 	: [0, 1]
	}
}


func get_damage(monster, damage):
	if monster.current_hp - damage <= 0:
		monster.current_hp = 0 
	else:
		monster.current_hp -= damage 
	return 

