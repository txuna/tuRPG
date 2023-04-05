extends CanvasLayer

@onready var ProgressControl = $ProgressConrol
@onready var ResultControl = $ResultControl
#@onready var monster_texture = $ProgressConrol/MonsterTexture
@onready var result_label = $ResultControl/ResultLabel
@onready var progress_bar = $ProgressConrol/TextureProgressBar
@onready var progress_value_label = $ProgressConrol/TextureProgressBar/ProgressBarValueLabel
#@onready var result_monster_texture = $ResultControl/MonsterTexture2

@onready var combat_log_container = $ScrollContainer/VBoxContainer
@onready var timer = $Timer


signal combat_finish(_region_id, win_flag)

var index = 0
var _combat_log = []
var win_flag = false 
var tween = null
var _region_id = 0

func init(flag):
	win_flag = flag

# Called when the node enters the scene tree for the first time.
func _ready():
	ProgressControl.visible = false 
	ResultControl.visible = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if tween:
		if not tween.is_running():
			tween.kill() 
			enable_result()


func make_font(font_size, color, h_align, v_align):
	var label = Label.new() 
	label.add_theme_color_override("font_color", color)
	label.add_theme_font_override("font", load("res://Assets/fonts/NanumBarunpenB.ttf"))
	label.add_theme_font_size_override("font_size", font_size)
	label.horizontal_alignment = h_align
	label.vertical_alignment = v_align
	return label 
	

func set_progress_label(value):
	progress_value_label.text = "{value}%".format({
		"value" : str(value)
	})


# combat_log 길이를 기반으로 체크
func enable_combat(region_id, combat_log):
	# 전투 로그 노드 초기화 
	for node in combat_log_container.get_children():
		node.queue_free() 
		
	
	_combat_log = combat_log
	_region_id = region_id
	ProgressControl.visible = true
	ResultControl.visible = false
	var second = combat_log.size() * 0.5
	#monster_texture.texture = Global.region_info[region_id].image#ImageTexture.create_from_image(Global.region_info[region_id].image)
	
	if tween:
		tween.kill() 
	
	tween = get_tree().create_tween()
	tween.set_parallel(true)	
	
	tween.tween_property(progress_bar, "value", 100, second)
	tween.tween_method(set_progress_label, 0, 100, second)
	timer.wait_time = 0.5
	timer.start()
	
	
func enable_result():
	PlayerState.init_hud()
	ProgressControl.visible = false 
	ResultControl.visible = true
	if win_flag:
		result_label.text = "승리!"
	else:
		result_label.text = "패배!"
	#result_monster_texture.texture = Global.region_info[_region_id].image#ImageTexture.create_from_image(Global.region_info[_region_id].image)


func _on_ok_btn_pressed():
	emit_signal("combat_finish", _region_id, win_flag)
	queue_free()


func _on_timer_timeout():
	if not _combat_log.size() > 0: 
		return 
		
	var msg = _combat_log[index]
	var label = make_font(12, Color.BLACK, HORIZONTAL_ALIGNMENT_LEFT, VERTICAL_ALIGNMENT_CENTER)
	label.text = msg 
	combat_log_container.add_child(label)
	index+=1 
	if index >= _combat_log.size():
		index = 0 
		timer.stop()
	
	
	
	
	
	
	
	
	
	
	
