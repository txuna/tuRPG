extends Node

const EQUIPMENT = 1
const CONSUMPTION = 2
const ETC = 3

const ONE_HAND = 10 # 한손검 
const TWO_HAND = 11 # 두손검 
const BOW = 12
const CROSS_BOW = 13
const WAND = 14
const STAFF = 15

const WEAPON = 1
const HAT = 2 
const SHIRT = 3 
const PANTS = 4
const SHOES = 5
const EARRING = 6
const RING = 7
const BELT = 8
const CLOAK = 9

const PHYSICAL = 1 
const MAGIC = 2

const comment_damage_type_string = {
	PHYSICAL : "물리", 
	MAGIC : "마법"
}



const comment_type_string = {
	HAT : "모자",
	SHIRT : "상의", 
	PANTS : "하의",
	SHOES : "신발", 
	EARRING : "귀고리",
	RING : "반지", 
	BELT : "벨트", 
	CLOAK : "망토",
	ONE_HAND : "한손 검",
	TWO_HAND : "두손 검", 
	BOW : "활", 
	CROSS_BOW : "석궁", 
	WAND : "완드", 
	STAFF : "스태프"
}

const WEAPON_VALUE = {
	ONE_HAND : {
		"value" : 1.4, 
		"speed" : 1.4
	}, 
	TWO_HAND : {
		"value" : 1.8, 
		"speed" : 0.8 
	}, 
	BOW : {
		"value" : 1.0, 
		"speed" : 1.8 
	}, 
	CROSS_BOW : {
		"value" : 1.5, 
		"speed" : 1.2
	},
	WAND : {
		"value" : 1.3, 
		"speed" : 1.5
	}, 
	STAFF : {
		"value" : 1.7, 
		"speed" : 1.2
	}
}

"""
	0 ~ 1000 : 무기 
	0 ~ 100 한손검 
	100 ~ 200 두손검 
	200 ~ 300 활 
	300 ~ 400 석궁 
	400 ~ 500 완드 
	500 ~ 600 스태프
	
	1000 ~ 2000 : 방어구  
	1000 ~ 1100 : 모자
	1100 ~ 1200 : 상의 
	1200 ~ 1300 : 하의 
	1300 ~ 1400 : 신발 
	1400 ~ 1500 : 귀고리 
	1500 ~ 1600 : 반지 
	1600 ~ 1700 : 벨트 
	1700 ~ 1800 : 망토 
	
	1800 ~ 2000 : 소비 아이템 
	2000 ~ 3000 : 기타 아이템
"""
# 기본 장비들은 프로토타입을 우선으로 하되 추가 능력치 기능 부여 
var prototype = {
	0 : {
		"info" : {
			"id" : 0, 
			"name" : "녹슨 검", 
			"image" : Image.load_from_file("res://Assets/equipment/weapon/one_hand/rusty_sword.png"), 
			"field" : ONE_HAND,
			"type" : PHYSICAL,
			"section" : WEAPON, 
			"inventory_type" : EQUIPMENT,
			"comment" : "여행자의 검이 300년 이상의 긴 세월을 정통을 겪은 녹이 슨 검이다.",
		}, 
		"state" : {
			"damage" : 5, 
		}
	},
	100 : {
		"info" : {
			"id" : 100, 
			"name" : "돌 검", 
			"image" : Image.load_from_file("res://Assets/equipment/weapon/two_hand/stone_sword.png"), 
			"field" : TWO_HAND, 
			"type" : PHYSICAL,
			"section" : WEAPON,
			"inventory_type" : EQUIPMENT,
			"comment" : "돌로된 둔기다. 석쇠구이 불판으로 쓰인다."
		}, 
		"state" : {
			"damage" : 7, 
			"armor" : 7, 
			"critical_percent" : 3 
		}
	},
	200 : {
		
	},
	1100 : {
		"info" :{ 
			"id" : 1100, 
			"name" : "허름한 셔츠",
			"image" : Image.load_from_file("res://Assets/equipment/armor/shirt/shabby_shirt.png"), 
			"type" : PHYSICAL,
			"section" : SHIRT, 
			"inventory_type" : EQUIPMENT,
			"comment" : "허르한 셔츠이다. 곧 찢어질듯 하다.",
		},
		"state" : {
			"max_hp" : 10, 
			"armor" : 15
		}
	},
	1800 : {
		"info" :{ 
			"id" : 1800, 
			"name" : "HP회복 포션",
			"image" : Image.load_from_file("res://Assets/consumption/hp_potion1.png"), 
			"inventory_type" : CONSUMPTION, 
			"comment" : "체력을 회복하는 물약이다. 체력을 50획복하는 효과를 지닌다."
		},
		"state" : {
			"current_hp" : 50
		}
	},
}
