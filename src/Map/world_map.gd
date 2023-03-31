extends Control

@onready var regions = $ColorRect/RegionControl
@onready var line_control = $ColorRect/LineControl 
@onready var player_control = $ColorRect/PlayerControl
@onready var player_node = $ColorRect/PlayerControl/Player

var is_dragging = false 
var previous_mouse_position = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	create_rigon_line()
	trigger_region_from_player(PlayerState.state.current_region_id)
	#var player_node = load("res://src/ui/player.tscn").instantiate()
	#player_control.add_child(player_node)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	gui_input()


func gui_input():
	if Input.is_action_just_pressed("pressed"):
		get_viewport().set_input_as_handled()
		previous_mouse_position = get_viewport().get_mouse_position()
		is_dragging = true


func _input(event):
	if not is_dragging:
		return 
	
	if Input.is_action_just_released("pressed"):
		previous_mouse_position = Vector2()
		is_dragging = false 

	# move limit = 0~1920, 0~1080 
	if is_dragging and event is InputEventMouseMotion:
		global_position += event.position - previous_mouse_position
		
		if global_position.x < -2080:
			global_position.x = -2080 
		if global_position.x > 0:
			global_position.x = 0
		if global_position.y < -1090:
			global_position.y = -1090
		if global_position.y > 0:
			global_position.y = 0

		previous_mouse_position = event.position


# 입력받은 region_id와 연결된 지역만 활성화 및 플레이어 생성
func trigger_region_from_player(region_id):
	var regions_node = get_node("ColorRect/RegionControl")
	var region = Global.region_info[region_id]
	for node in regions_node.get_children():
		if (node.region_id in region.connected) or (node.region_id == region_id):
			node.enable_region() 
		else:
			node.disable_region()
	
	var region_node = get_region_node(region_id) 
	# 전투 승리시 이동
	var tween = get_tree().create_tween()
	tween.tween_property(player_node, "global_position", region_node.global_position, 1)
	#player_node.global_position = region_node.global_position
	

# 각 점에 대한 라인 생성? 
func create_rigon_line():
	for key in Global.region_info:
		var region = Global.region_info[key]
		var node = get_region_node(region.id)
		if node == null:
			continue 
		
		for connected_region_id in region.connected:
			var connected_node = get_region_node(connected_region_id)
			if connected_node == null:
				continue 
		
			var line = Line2D.new() 
			line.width = 7
			line.add_point(node.get_center_position())
			line.add_point(connected_node.get_center_position())
			line.joint_mode = Line2D.LINE_JOINT_ROUND
			line.begin_cap_mode = Line2D.LINE_CAP_ROUND
			line.default_color = Color.DARK_GRAY
			line_control.add_child(line)


func get_region_node(id):
	var regions = get_node("ColorRect/RegionControl")
	for node in regions.get_children():
		if node.region_id == id:
			return node
			
	return null


