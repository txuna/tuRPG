extends Node2D


@onready var center_position = $CenterPosition
@export var region_id:int = 1

var is_disabled = true
var mainview_path = null

# Called when the node enters the scene tree for the first time.
func _ready():
	mainview_path = get_node("/root/MainView")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_region_btn_pressed():
	if not Global.region_info.has(region_id):
		return 
		
	var region_info = Global.region_info[region_id]
	var popup_instance = load("res://src/ui/popup.tscn").instantiate()	
	
	popup_instance.init(region_info)
	mainview_path.add_child(popup_instance)
	popup_instance.global_position = Vector2(50, 180)
	popup_instance.adventure_region.connect(mainview_path._on_adventure_region)


func get_center_position():
	return center_position.global_position
