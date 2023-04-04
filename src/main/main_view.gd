extends Node2D

signal fin

@onready var MenuControl = $MenuControl 
@onready var world_map = $TopView/WorldMap
#@onready var inventory_popup = $InventoryPopup
#@onready var state_popup = $StatePopup

# Called when the node enters the scene tree for the first time.
# 플레이어 스탯 초기화도 진행? 
func _ready():
	MenuControl.toggle_inventory.connect(_on_toggle_inventory)
	MenuControl.toggle_state.connect(_on_toggle_state)
	MenuControl.toggle_quest.connect(_on_toggle_quest)
	
	PlayerState.init_hud()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_toggle_inventory():
	var inventory_popup = get_node_or_null("/root/MainView/InventoryPopup")
	if inventory_popup == null:
		inventory_popup = load("res://src/ui/inventory_popup.tscn").instantiate() 
		add_child(inventory_popup)
		inventory_popup._on_open_inventory()
	else:
		inventory_popup.queue_free()


func _on_toggle_state():
	var state_popup = get_node_or_null("/root/MainView/StatePopup")
	if state_popup == null:
		state_popup = load("res://src/ui/state_popup.tscn").instantiate() 
		add_child(state_popup)
		state_popup._on_open_state()
	else:
		state_popup.queue_free()
		
	
	
func _on_toggle_quest():
	pass


func open_village(village_id):
	var village = Global.village_info[village_id] 
	var node = (village.scene).instantiate() 
	add_child(node)
	node.init(village_id)
	
	

# 해당 지역에 따른 오픈
# 플레이어 이동
# 해당 팝업이 오픈중일떄는 이동 불가
func _on_adventure_region(region_id):
	var region = Global.region_info[region_id]
	# 마을의 경우 즉시 이동 
	if region.type == Global.VILLAGE:
		PlayerState.change_region(region_id)
		world_map.trigger_region_from_player(region_id)
		var village_id = Global.region_info[region_id].type_id
		open_village(village_id)
		
		
	elif region.type == Global.MONSTER:
		simulate_combat(region_id, region.type_id)


# 전투에서 승리하여야만 해당 지역 이동 가능
func _on_combat_finished(region_id, win_flag):
	# 패배시 게임종료 플래스 선언
	if not win_flag:
		var game_over_instance = load("res://src/ui/game_over_popup.tscn").instantiate()
		add_child(game_over_instance)
		return 
		
	PlayerState.change_region(region_id)
	world_map.trigger_region_from_player(region_id)
	var monster_id = Global.region_info[region_id].type_id 
	get_reward_from_monster(monster_id)
	

# 스피드를 기반으로 선공 확인 
# 상대 한명이 hp가 0이 되기전까지 전투 시뮬레이션 
# return false : 패배 
# return true : 승리 
# popup창이랑 전투랑 thread로 나눠야 하는가 
func simulate_combat(region_id, id):
	var reword_popup_instance = load("res://src/ui/reword_popup.tscn").instantiate()
	reword_popup_instance.combat_finish.connect(_on_combat_finished)
	add_child(reword_popup_instance)
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
		
		"""	
		print("{attacker} give {damage} to {victim} and has {hp}".format({
			"attacker" : combat_order[0].name, 
			"damage" : damage, 
			"victim" : combat_order[1].name, 
			"hp" : combat_order[1].current_hp
		}))
		"""	
		combat_order.reverse()
		#damage = calculate_damage(combat_order[1], combat_order[1]) 
	
	# 플레이어 패배
	if player_state.current_hp <= 0:
		reword_popup_instance.init(false)
	
	# 플레이어 승리 
	else:
		reword_popup_instance.init(true)
		# 전리품 추가 루틴 

	reword_popup_instance.enable_combat(region_id)


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
	if attacker.damage_type == Global.PHYSICAL:
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

	
# 몬스터로부터 전리품 획득
func get_reward_from_monster(monster_id):
	var reward = Global.monster_spoil[monster_id]
	# 코인 증가 
	PlayerState.get_coin(reward.coin)
	# 경험치 증가
	PlayerState.get_exp(reward.exp)
	
	var item_list = []
	for item_id in reward.item:
		randomize() 
		# 아이템 프로토타입을 가지고옴
		var prototype = Equipment.prototype[item_id]
		var inventory_type = prototype.info.inventory_type
		var percent = reward.item[item_id]
		# 확률에 의하여 아이템이 뜨지 않은 상황
		if percent < randf_range(0.00, 100.00):
			continue 
		
		# 인벤토리 용량 초과 체크 및 추가 (장비아이템의 경우 랜덤 에디셔널) 
		# 소비나 기타의 경우 해당 아이템이 있는지 확인
		if inventory_type == Equipment.EQUIPMENT:
			# 정상적으로 얻었다면
			if PlayerState.get_item(item_id, "equipment", true) != -1:
				item_list.append(item_id)
		elif inventory_type == Equipment.CONSUMPTION:
			if PlayerState.get_item(item_id, "consumption") != -1:
				item_list.append(item_id)
		elif inventory_type == Equipment.ETC:
			if PlayerState.get_item(item_id, "etc") != -1:
				item_list.append(item_id)
	
	# 전리품 화면 출력	
	var spoil_popup_node = load("res://src/ui/spoil_popup.tscn").instantiate()
	add_child(spoil_popup_node)
	spoil_popup_node.set_spoils(reward.coin, reward.exp, item_list)


# 경고창 출력
func open_alert_popup(msg):
	var msg_string = Global.comment_alert[msg]
	var alert_node = load("res://src/ui/alert_popup.tscn").instantiate() 
	add_child(alert_node)
	alert_node.set_content_text(msg_string)



