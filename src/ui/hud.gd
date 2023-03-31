extends CanvasLayer


@onready var hp_bar = $HpBar
@onready var exp_bar = $ExpBar
@onready var hp_label = $HpValueLabel
@onready var exp_label = $ExpValueLabel
@onready var level_label = $LevelLabel
@onready var coin_label = $CoinLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerState.set_hp_event.connect(_on_set_hp)
	PlayerState.set_exp_event.connect(_on_set_exp)
	PlayerState.set_level_event.connect(_on_set_level)
	PlayerState.set_coin_event.connect(_on_set_coin)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# current / max 비율로 체크 -> isgnal 
func _on_set_hp():
	var player_state = PlayerState.state
	var current_hp = player_state.current_hp 
	var max_hp = player_state.max_hp
	##hp_bar.value = int(float(current_hp) / float(max_hp) * 100)
	hp_label.text = "[{current} / {max}]".format({
		"current" : str(current_hp), 
		"max" : str(max_hp)
	})
	
	var tween = get_tree().create_tween()
	tween.tween_property(hp_bar, "value", int(float(current_hp) / float(max_hp) * 100),  1)
	
	
func _on_set_exp():
	var player_state = PlayerState.state
	var current_exp = player_state.current_exp 
	var max_exp = player_state.max_exp 
	#exp_bar.value = int(float(current_exp) / float(max_exp) * 100)
	exp_label.text = "[{current} / {max}]".format({
		"current" : str(current_exp), 
		"max" : str(max_exp)
	})
	var tween = get_tree().create_tween()
	tween.tween_property(exp_bar, "value", int(float(current_exp) / float(max_exp) * 100), 1)
	

func _on_set_level():
	var player_state = PlayerState.state
	var level = player_state.level
	level_label.text = "Lv. {level}".format({
		"level" : str(level)
	})
	

func _on_set_coin():
	var player_state = PlayerState.state
	var coin = player_state.coin 
	coin_label.text = "{coin}$".format({
		"coin" : str(coin)
	})
