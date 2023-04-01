extends CanvasLayer

@onready var ProgressControl = $ProgressConrol
@onready var ResultControl = $ResultControl
@onready var monster_texture = $ProgressConrol/MonsterTexture
@onready var result_label = $ResultControl/ResultLabel
@onready var progress_bar = $ProgressConrol/TextureProgressBar
@onready var progress_value_label = $ProgressConrol/TextureProgressBar/ProgressBarValueLabel
@onready var result_monster_texture = $ResultControl/MonsterTexture2

signal combat_finish(_region_id, win_flag)

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

func set_progress_label(value):
	progress_value_label.text = "{value}%".format({
		"value" : str(value)
	})


func enable_combat(region_id):
	_region_id = region_id
	ProgressControl.visible = true
	ResultControl.visible = false
	monster_texture.texture = ImageTexture.create_from_image(Global.region_info[region_id].image)
	if tween:
		tween.kill() 
	
	tween = get_tree().create_tween()
	tween.set_parallel(true)	
		
	tween.tween_property(progress_bar, "value", 100, 3)
	tween.tween_method(set_progress_label, 0, 100, 3)
	
	

func enable_result():
	PlayerState.init_hud()
	ProgressControl.visible = false 
	ResultControl.visible = true
	if win_flag:
		result_label.text = "승리!"
	else:
		result_label.text = "패배!"
	result_monster_texture.texture = ImageTexture.create_from_image(Global.region_info[_region_id].image)


func _on_ok_btn_pressed():
	emit_signal("combat_finish", _region_id, win_flag)
	queue_free()
