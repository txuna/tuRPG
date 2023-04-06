extends CanvasLayer

@onready var shop_title_label = $Control/ShopTitleLabel
@onready var shop_container = $Control/TextureRect/BuyContainer/ScrollContainer/VBoxContainer
@onready var inventory_container = $Control/TextureRect/SellContainer/ScrollContainer/VBoxContainer
@onready var player_coin_label = $Control/CoinLabel

var inventory_type = "equipment"
var shop_info = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func init(info):
	shop_info = info
	shop_title_label.text = shop_info.name


func open():
	_on_display_shop()
	_on_display_inventory()
	_on_display_coin()
	

func update_shop():
	open()
	

func make_font(font_size, color, h_align, v_align):
	var label = Label.new() 
	label.add_theme_color_override("font_color", color)
	label.add_theme_font_override("font", load("res://Assets/fonts/NanumBarunpenB.ttf"))
	label.add_theme_font_size_override("font_size", font_size)
	label.horizontal_alignment = h_align
	label.vertical_alignment = v_align
	return label 
	


func _on_sell_item(item, price):
	PlayerState.sell_item(item, price)
	#update_shop()
	

func _on_buy_item(id, price):
	PlayerState.buy_item(id, price)
	#update_shop()
	

func _on_display_coin():
	player_coin_label.text = "Coin: {coin}$".format({"coin" : str(PlayerState.state.coin)})
	

func _on_display_shop():
	# 기존 노드 초기화 
	for node in shop_container.get_children():
		node.queue_free()
	
	for product_id in shop_info.product:
		var hbox_container = HBoxContainer.new() 
		var outer_texture = TextureRect.new() 
		var inner_texture = TextureRect.new() 
		var inner_hbox = HBoxContainer.new() 
		var inner_vbox = VBoxContainer.new() 
		var name_label = make_font(24, Color.BLACK, HORIZONTAL_ALIGNMENT_LEFT, VERTICAL_ALIGNMENT_CENTER)
		var coin_label = make_font(16, Color.BLACK, HORIZONTAL_ALIGNMENT_LEFT, VERTICAL_ALIGNMENT_CENTER)
		var button = Button.new() 
		var prototype = Equipment.prototype[product_id]
		
		outer_texture.texture = load("res://Assets/ui/inventory_slot.png")
		inner_texture.texture = prototype.info.image
		outer_texture.gui_input.connect(_on_open_detail.bind({
			"prototype_id" : product_id, 
			"additional_state" : {},
			"option" : Equipment.ZERO_OPTION
		}))
		
		inner_hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		hbox_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		inner_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		coin_label.text = "가격: {coin}$".format({"coin" : str(prototype.price.buy)})
		name_label.text = "{name}".format({"name" : prototype.info.name})
		
		button.add_theme_font_override("font", load("res://Assets/fonts/NanumBarunpenB.ttf"))
		button.add_theme_font_size_override("font_size", 32)
		button.text = "구매"
		button.pressed.connect(_on_buy_item.bind(product_id, prototype.price.buy))
		
		inner_vbox.add_child(name_label)
		inner_vbox.add_child(coin_label)
		inner_hbox.add_child(inner_vbox)
		inner_hbox.add_child(button)
		outer_texture.add_child(inner_texture)
		hbox_container.add_child(outer_texture)
		hbox_container.add_child(inner_hbox)
		shop_container.add_child(hbox_container)
		
	

func _on_display_inventory():
	var player_inventory = PlayerState.inventory[inventory_type]
	# 기존 노드 초기화 
	for node in inventory_container.get_children():
		node.queue_free()
	
	for item in player_inventory:
		var item_id = item.prototype_id 
		var hbox_container = HBoxContainer.new() 
		var outer_texture = TextureRect.new() 
		var inner_texture = TextureRect.new() 
		var inner_hbox = HBoxContainer.new() 
		var inner_vbox = VBoxContainer.new() 
		var name_label = make_font(24, Color.BLACK, HORIZONTAL_ALIGNMENT_LEFT, VERTICAL_ALIGNMENT_CENTER)
		var coin_label = make_font(16, Color.BLACK, HORIZONTAL_ALIGNMENT_LEFT, VERTICAL_ALIGNMENT_CENTER)
		var button = Button.new() 
		var prototype = Equipment.prototype[item_id]
		
		outer_texture.texture = load("res://Assets/ui/inventory_slot.png")
		inner_texture.texture = prototype.info.image
		outer_texture.gui_input.connect(_on_open_detail.bind(item))
		
		inner_hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		hbox_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		inner_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		# 소비나 기타아이템의 경우 갯수도 포함
		if prototype.info.inventory_type != Equipment.EQUIPMENT:
			coin_label.text = "가격: {coin}$ 갯수: {count}개".format({
				"coin" : str(prototype.price.sell),
				"count" : str(item.count)
			})
		else:
			coin_label.text = "가격: {coin}$".format({
				"coin" : str(prototype.price.sell)
			})
		name_label.text = "{name}".format({"name" : prototype.info.name})
		
		button.add_theme_font_override("font", load("res://Assets/fonts/NanumBarunpenB.ttf"))
		button.add_theme_font_size_override("font_size", 32)
		button.text = "판매"
		button.pressed.connect(_on_sell_item.bind(item, prototype.price.sell))
		
		inner_vbox.add_child(name_label)
		inner_vbox.add_child(coin_label)
		inner_hbox.add_child(inner_vbox)
		inner_hbox.add_child(button)
		outer_texture.add_child(inner_texture)
		hbox_container.add_child(outer_texture)
		hbox_container.add_child(inner_hbox)
		inventory_container.add_child(hbox_container)


func _on_open_detail(event: InputEvent, item):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and not event.pressed:		
			var detail_popup = load("res://src/ui/detail_popup.tscn").instantiate() 
			get_parent().add_child(detail_popup)
			detail_popup._on_open_detail_popup(item)
	return 


func _on_exit_btn_pressed():
	queue_free()


func _on_etc_btn_pressed():
	inventory_type = "etc"
	_on_display_inventory()


func _on_equipment_btn_pressed():
	inventory_type = "equipment"
	_on_display_inventory()


func _on_consumption_btn_pressed():
	inventory_type = "consumption"
	_on_display_inventory()
	
