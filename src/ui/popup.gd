extends Control

signal adventure_region(region_id)

@onready var title_label = $Bar/TitleLabel 
@onready var region_texture = $RegionImage 
@onready var monster_info_label = $MonsterInfoLabel

var region = null
var monster = null

func init(_region):
	region = _region

# Called when the node enters the scene tree for the first time.
func _ready():
	region_texture.texture = ImageTexture.create_from_image(region.image)
	title_label.text = region.region_name
	
	if region.type == Global.VILLAGE:
		return 
		
	monster = Global.monster_info[region.type_id]
	monster_info_label.text = "Lv.{level} {name}".format({
		"level" : monster.level, 
		"name"  : monster.name
	})
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_adventure_btn_pressed():
	emit_signal("adventure_region", region.id)
	queue_free()


func _on_exit_btn_pressed():
	queue_free()
