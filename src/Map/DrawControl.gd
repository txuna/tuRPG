extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# 이미 연결된 점이라면 패스하기
# 맵이 움직일 때 마다 다시 그려야 하나 
func _draw():
	for key in Global.region_info:
		var region = Global.region_info[key]
		var node = get_region_node(region.id)
		if node == null:
			continue 
		
		for connected_region_id in region.connected:
			var connected_node = get_region_node(connected_region_id)
			if connected_node == null:
				continue 
		
			draw_line(node.get_center_position(), connected_node.get_center_position(), Color.BLACK, 2)


func get_region_node(id):
	var regions = get_parent().get_node("RegionControl")
	for node in regions.get_children():
		if node.region_id == id:
			return node
			
	return null
