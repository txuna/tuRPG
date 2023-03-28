extends Node2D

signal fin

@onready var MenuControl = $MenuControl 

# Called when the node enters the scene tree for the first time.
func _ready():
	MenuControl.toggle_inventory.connect(_on_toggle_inventory)
	MenuControl.toggle_state.connect(_on_toggle_state)
	MenuControl.toggle_quest.connect(_on_toggle_quest)
	
	PlayerState.init_hud()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_toggle_inventory():
	pass

func _on_toggle_state():
	pass
	
func _on_toggle_quest():
	pass

# 해당 지역에 따른 오픈
func _on_adventure_region(region_id):
	var region = Global.region_info[region_id]
	if region.type == Global.VILLAGE:
		pass
		
	elif region.type == Global.MONSTER:
		if simulate_combat(region.type_id):
			pass


# 스피드를 기반으로 선공 확인 
# 상대 한명이 hp가 0이 되기전까지 전투 시뮬레이션 
# return false : 패배 
# return true : 승리 
func simulate_combat(id):
	var monster = Global.monster_info[id].duplicate() 
	var player_state = PlayerState.state 
	var combat_order = [] 
	
	if player_state.speed >= monster.speed:
		combat_order.append(player_state)
		combat_order.append(monster)
		
	else:
		combat_order.append(monster)
		combat_order.appnd(player_state)
	
	var damage = 0
	# 둘 중 하나가 current_hp가 0이 되면 전투 종료
	while (player_state.current_hp > 0 and monster.current_hp > 0):
		damage = calculate_damage(combat_order[0], combat_order[1])
		if combat_order[0].name == "player":
			Global.get_damage(combat_order[1], damage)
		else:
			PlayerState.get_damage(damage)
			
		print("{attacker} give {damage} to {victim} and has {hp}".format({
			"attacker" : combat_order[0].name, 
			"damage" : damage, 
			"victim" : combat_order[1].name, 
			"hp" : combat_order[1].current_hp
		}))
		combat_order.reverse()
		#damage = calculate_damage(combat_order[1], combat_order[1]) 

	if player_state.current_hp <= 0:
		print("monster win")
	
	else:
		print("player win")
		


# 상대방에 적용될 데미지 계산 
func calculate_damage(attacker, victim):
	randomize() 
	var damage = attacker.damage 
	# 크리티컬 데미지 계산 
	if attacker.critical_percent >= randf_range(0.0, 100.0):
		damage = float(damage * (1.0 + float(attacker.critical_damage / 100.0)))
	
	# 최종데미지 계산
	damage = damage * (1.0 + float(attacker.final_damage / 100.0))
	# 상대 방어력 계산 - 공격자의 무기에 따른 마저, 방관 적용 
	var defense_value = 0 
	if victim.damage_type == Global.PHYSICAL:
		if float(victim.armor) - float(attacker.armor_penetration) <= 0.0:
			defense_value = 0
		else:
			defense_value = float(victim.armor) - float(attacker.armor_penetration)
	else:
		if float(victim.magic_resistance) - float(attacker.magic_resistance_penetration) <= 0.0:
			defense_value = 0
		else:
			defense_value = float(victim.magic_resistance) - float(attacker.magic_resistance_penetration)

	# 방어자의 방어 퍼센트확인 
	#300 * ((100 - (53 / (100 + 53)) * 100) / 100)
	damage = int(damage * float(float(100.0 - float(defense_value / float(Global.DEFENSE_CONSTANT + defense_value)) * 100) / 100.0))

	# 회피율 계산 
	randomize() 
	if victim.avoidance_rate >= randf_range(0.0, 100.0):
		damage = 0
	
	return damage 
	







