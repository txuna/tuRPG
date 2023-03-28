extends Node

signal set_hp_event
signal set_exp_event
signal set_level_event

var PHYSICAL = 1 
var MAGIC = 2

var state = {
	"damage" : 10, 							# 공격력(마력) 
	"critical_percent" : 10.0,				# 크리티컬 확률 
	"critical_damage" : 30.0, 				# 크리티컬 데미지
	"armor" : 10.0,							# 방어력
	"magic_resistance" : 10, 				# 마법저항력
	"avoidance_rate" : 10.0, 					# 회피율
	"speed" : 10.0, 							# 스피드 
	"final_damage" : 15.0, 					# 최종데미지 
	"armor_penetration" : 10.0, 				# 방관
	"magic_resistance_penetration" : 10.0, 	# 마관
	"max_hp" : 100,							# 최대 체력 
	"current_hp" : 100, 						# 현재 체력
	"max_exp" : 10,							# 최대 경험치
	"current_exp" : 3, 						# 현재 경험치 
	"level" : 1,							# 현재 레벨,
	"current_region" : 0,					# 플레이어 현재 위치 
	"damage_type" : PHYSICAL,				# 데미지 타입
	"name" : "player"
}

# 검사 로직은 player단에서
func change_hp(value):
	if state.current_hp + value >= state.max_hp:
		state.current_hp = state.max_hp 
	
	elif state.current_hp + value <= 0:
		state.current_hp = 0 
	
	else:	
		state.current_hp += value 
	
	emit_signal("set_hp_event")
	return 
	
	
func init_hud():
	emit_signal("set_exp_event")	
	emit_signal("set_hp_event")
	emit_signal("set_level_event")	
	
	
func change_exp(value):
	pass


func get_damage(damage):
	change_hp(-damage)
