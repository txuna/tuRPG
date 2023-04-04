extends "res://src/ui/village_popup.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# 상점 클릭
func _on_shop_npc_pressed():
	var shop_node = load("res://src/ui/shop_popup.tscn").instantiate() 
	get_parent().add_child(shop_node)
	# NPC 코드
	shop_node.init(village.npc[0])
	shop_node.open()
