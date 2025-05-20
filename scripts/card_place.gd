class_name CardPlace extends Node2D

var card: Card = null
var mouse_is_inside_the_card: bool = false
var this_area_is_enetered = false
signal joker_bought(card: Card) 
@onready var buy_button = $Buy_button
@onready var gold_cost_label = $gold_cost_label


func _ready() -> void:
	buy_button.hide()
	gold_cost_label.hide()
	if not buy_button.is_connected("pressed", Callable(self, "_on_buy_button_pressed")):
		buy_button.connect("pressed", Callable(self, "_on_buy_button_pressed"))
		
func _input(event):

	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT and event.pressed and mouse_is_inside_the_card:
		if get_parent().get_parent().topaz_touch == true:
			if card:
				card.highlight_topaz_card()
				card.topaz = true
				card.emerald = false
				card.ruby = false
				card.sapphire = false
			get_parent().get_parent().topaz_touch = false
			var cursor_texture = load("res://sprites/cursor.png")
			Input.set_custom_mouse_cursor(cursor_texture)
			
		if get_parent().get_parent().emerald_touch == true:
			if card:
				card.highlight_emerald_card()
				card.topaz = false
				card.emerald = true
				card.ruby = false
				card.sapphire = false
			get_parent().get_parent().emerald_touch = false
			var cursor_texture = load("res://sprites/cursor.png")
			Input.set_custom_mouse_cursor(cursor_texture)
			
		if get_parent().get_parent().ruby_touch == true:
			if card:
				card.highlight_ruby_card()
				card.topaz = false
				card.emerald = false
				card.ruby = true
				card.sapphire = false
			get_parent().get_parent().ruby_touch = false
			var cursor_texture = load("res://sprites/cursor.png")
			Input.set_custom_mouse_cursor(cursor_texture)
			
		if get_parent().get_parent().sapphire_touch == true:
			if card:
				card.highlight_sapphire_card()
				card.topaz = false
				card.emerald = false
				card.ruby = false
				card.sapphire = true
			get_parent().get_parent().sapphire_touch = false
			var cursor_texture = load("res://sprites/cursor.png")
			Input.set_custom_mouse_cursor(cursor_texture)
			
func _process(delta: float) -> void:
	pass

func set_card(_card: Card) -> void:
	add_child(_card)
	buy_button.position.y = 7
	card = _card
	gold_cost_label.show()
	var joker = turn_card_into_a_joker(_card)
	if joker:
		gold_cost_label.set_text(str(joker.effect.joker_price))
		
func turn_card_into_a_joker(card: Card) -> Joker:
	var path: String = "res://scenes/jokers/Joker_" + str(card.card_value) + "_" + str(card.card_suit) + ".tscn"
	var joker_scene = load(path)
	if joker_scene:
		var joker = joker_scene.instantiate()
		if joker:
			joker.card_value = card.card_value
			joker.card_suit = card.card_suit
			joker.card_path = card.card_path
			joker.connect("mouse_entered_joker", Callable(self, "_on_mouse_entered_joker"))
			joker.connect("mouse_exited_joker", Callable(self, "_on_mouse_exited_joker"))
			return joker
	return null
	
func _on_area_2d_mouse_entered() -> void:
	if this_area_is_enetered == false and card != null and get_parent().get_parent().is_dragging_a_joker == false:
		this_area_is_enetered = true
		mouse_is_inside_the_card = true
		card.position.y -= 2
		card.highlight()
		buy_button.show()
		buy_button.position.y += 21
		var joker = turn_card_into_a_joker(card)
		if joker:
			get_parent().get_parent().joker_effect_label.set_text(joker.effect.joker_effect)
	
	
func _on_area_2d_mouse_exited() -> void:
	if this_area_is_enetered == true and card != null and get_parent().get_parent().is_dragging_a_joker == false:
		this_area_is_enetered = false
		mouse_is_inside_the_card = false
		card.position.y += 2
		card.unhighlight()
		buy_button.position.y -= 21
		buy_button.hide()
		get_parent().get_parent().joker_effect_label.set_text('')


func _on_buy_button_pressed() -> void:
	var total_gold = get_parent().get_parent().get_parent().total_gold
	var cost = int(gold_cost_label.get_text())
	if cost <= total_gold:
		var number_of_jokers = 0
		for joker_place in get_parent().get_parent().jokers.get_children():
			if joker_place.joker != null: 
				number_of_jokers += 1
		if number_of_jokers < 5:
			mouse_is_inside_the_card = false
			get_parent().get_parent().get_parent().total_gold -= cost
			emit_signal("joker_bought", card)
			remove_child(card)
			buy_button.position.y -= 21
			buy_button.hide()
			gold_cost_label.hide()
			get_parent().get_parent().joker_effect_label.set_text('')
			get_parent().get_parent().gold_ammount_label.set_text(str(get_parent().get_parent().get_parent().total_gold))
			_on_area_2d_mouse_exited()


func _on_buy_button_mouse_entered() -> void:
	buy_button.icon = load("res://sprites/buy_button_hovered.png")


func _on_buy_button_mouse_exited() -> void:
	buy_button.icon  = load("res://sprites/buy_button.png")
