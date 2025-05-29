class_name Shop extends Node2D

@onready var soundfx_player = $soundfx_player
@onready var card_scene: PackedScene = preload("res://scenes/card.tscn")
@onready var card_back = preload("res://scenes/card_back.tscn")
@onready var spawnpoints = $spawnpoints.get_children() 
var drawn_cards = []
var original_deck: Deck = null

@onready var deck = $deck_position
@onready var desk: Sprite2D = $desk
@onready var jokers = $Jokers
@onready var joker_effect_label = $joker_effect_label
@onready var sell_joker_label = $sell_joker_label
@onready var gold_ammount_label = $gold_ammount_label
@onready var excavate_cards_button = $excavate
@onready var excavation_cost_label = $excavate/excavation_cost_label
@onready var next_button = $next_button

@onready var gem_1_position = $desk/gems_positions/gem_1_position
@onready var gem_2_position = $desk/gems_positions/gem_2_position
@onready var gem_3_position = $desk/gems_positions/gem_3_position

@onready var small_topaz = $small_topaz
@onready var small_sapphire = $small_sapphire
@onready var small_emerald = $small_emerald
@onready var small_ruby = $small_ruby

@onready var medium_topaz = $medium_topaz
@onready var medium_sapphire = $medium_sapphire
@onready var medium_emerald = $medium_emerald
@onready var medium_ruby = $medium_ruby

@onready var big_topaz = $big_topaz
@onready var big_sapphire = $big_sapphire
@onready var big_emerald = $big_emerald
@onready var big_ruby = $big_ruby

@onready var desk_next_button_bigger = $ShopDeskNextButtonBigger
@onready var desk_excavate_button_bigger = $ShopDeskExcavateButtonBigger

var all_gems_list: Array 
var chosen_gems: Array

var topaz_touch: bool = false
var emerald_touch: bool = false
var ruby_touch: bool = false
var sapphire_touch: bool = false

var current_selected_joker_for_movement = null
var is_dragging_a_joker: bool = false

var excavation_cost: int = 1

signal show_board

var main: Main 
	
func set_deck(deck: Deck) -> void:
	original_deck = deck
	
func get_random_card_from_deck() -> Card:
	if get_parent() and original_deck and original_deck.card_collection.size() > 0:
		var random_index = randi() % GameInfo.original_deck.card_collection.size()
		if original_deck.card_collection.has(random_index):
			return original_deck.card_collection[random_index]
		else:
			return get_random_card_from_deck()
	else:
		return null

func excavate_card() -> void:
	excavate_cards_button.hide()
	next_button.hide()
	var card = get_random_card_from_deck()
	if check_if_card_can_be_excavated(card): 
		drawn_cards.append(card)  
		play_this_sound_effect("res://sound/effects/card_flip_and_place_on_the_table_1.mp3")
		for card_place in spawnpoints:
			if !card_place.has_node("Card"):
				var temp_card_back = card_back.instantiate()
				temp_card_back.global_position = deck.global_position
				get_tree().current_scene.add_child(temp_card_back)

				var tween = get_tree().create_tween()
				tween.tween_property(temp_card_back, "global_position", card_place.global_position, 0.27)\
					.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

				await tween.finished

				var flip_tween = get_tree().create_tween()
				flip_tween.tween_property(temp_card_back, "scale:x", 0.0, 0.1)\
					.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

				await flip_tween.finished
				temp_card_back.queue_free()

				card.scale.x = 0.0
				card_place.set_card(card)
				card.set_card_sprite(card.card_path)

				var flip_open = get_tree().create_tween()
				flip_open.tween_property(card, "scale:x", 1.0, 0.1)\
					.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

				await flip_open.finished
				excavate_cards_button.show()
				next_button.show()
				return
	else:
		excavate_card()

func check_if_card_can_be_excavated(new_card: Card) -> bool:
	if !new_card:
		return false
		
	for card in drawn_cards:
		if card.card_suit == new_card.card_suit && card.card_value == new_card.card_value:
			return false
	return true

func load_jokers() -> void:
	var main_jokers = get_parent().jokers
	if main_jokers:
		for i in range(0,5):
			if main_jokers.get_child(i).joker != null:
				var joker = main_jokers.get_child(i).joker.duplicate(DUPLICATE_SCRIPTS | DUPLICATE_GROUPS | DUPLICATE_SIGNALS)
				joker.connect("mouse_entered_joker", Callable(self, "_on_mouse_entered_joker"))
				joker.connect("mouse_exited_joker", Callable(self, "_on_mouse_exited_joker"))
				joker.connect("joker_sold", Callable(self, "_on_joker_sold"))
				jokers.get_child(i).set_joker(joker)
	
func _on_mouse_entered_joker(joker: Joker) -> void:
	if joker.has_node("effect"):
		var child = joker.get_node("effect")
		joker_effect_label.text = str(child.joker_effect)
		var sell_value: int = int(joker.effect.joker_price / 2)
		sell_joker_label.set_text("Right click to sell for: " + str(sell_value) + " gold.")

func _on_mouse_exited_joker() -> void:
	joker_effect_label.text = ""
	sell_joker_label.set_text('')

func _on_joker_sold(joker: Joker) -> void:
	for joker_place in jokers.get_children():
		if joker_place.joker == joker:
			joker_place.remove_child(joker)
			joker_place.joker = null
			var card = turn_joker_into_a_card(joker)
			original_deck.add_card(card)
			GameInfo.original_deck.add_card(card)
			GameInfo.total_gold += int(joker.effect.joker_price / 2)
			gold_ammount_label.set_text(str(GameInfo.total_gold))
			sell_joker_label.set_text("")
			get_parent().set_jokers(jokers)
			get_parent().save_jokers()
			GameInfo.save_game()

func turn_joker_into_a_card(joker: Joker) -> Card:
	var card: Card = card_scene.instantiate()
	card.set_card_value(joker.card_value)
	card.set_card_suit(joker.card_suit)
	card.set_card_path(joker.card_path)
	return card

func get_three_unique_gems():
	var shuffled_gems = all_gems_list.duplicate()
	shuffled_gems.shuffle() 
	return shuffled_gems.slice(0, 3)
	
	
func _ready() -> void:
	all_gems_list = [small_emerald, small_ruby, small_sapphire, small_topaz, medium_emerald, medium_ruby, medium_sapphire, medium_topaz, big_topaz, big_emerald, big_ruby, big_sapphire]
	chosen_gems = get_three_unique_gems()
	chosen_gems[0].global_position = gem_1_position.global_position
	chosen_gems[1].global_position = gem_2_position.global_position
	chosen_gems[2].global_position = gem_3_position.global_position
	
	for gem_button in chosen_gems:
		var icon = gem_button.get_node("Icon") if gem_button.has_node("Icon") else null
		if icon and icon.material and icon.material is ShaderMaterial:
			icon.material.set_shader_param("shine_pos", 0.5)
			
	excavation_cost = 1
	excavation_cost_label.set_text("- " + str(excavation_cost) + " gold")
		
	joker_effect_label.z_index = 100
	load_jokers()
	
	gold_ammount_label.set_text(str(GameInfo.total_gold))
	for card_place in spawnpoints:
		card_place.connect("joker_bought", Callable(self, "_on_joker_bought"))
	
func _on_button_pressed() -> void:
	await play_this_sound_effect("res://sound/effects/button_click.mp3")
	get_parent().set_jokers(jokers)
	for joker_place in jokers.get_children():
		if joker_place.joker != null:
			joker_place.joker.free()
		joker_place.free()
	GameInfo.original_deck = copy_deck()
	emit_signal("show_board") 
	hide()  

func copy_deck() -> Deck:
	var deck_copy = Deck.new()

	for card_id in original_deck.card_collection.keys():
		var card = original_deck.card_collection[card_id]
		if is_instance_valid(card):
			var new_card = card.duplicate() 
			if card.topaz:
				new_card.topaz = true
			if card.emerald:
				new_card.emerald = true
			if card.ruby:
				new_card.ruby = true
			if card.sapphire:
				new_card.sapphire = true
			deck_copy.add_card(new_card)
	
	return deck_copy
	
func _on_exacuviate_pressed() -> void:
	if excavation_cost <= GameInfo.total_gold and drawn_cards.size() < 8:
		play_this_sound_effect("res://sound/effects/button_click.mp3")
		GameInfo.total_gold -= excavation_cost
		excavation_cost += 1
		excavation_cost_label.set_text("- " + str(excavation_cost) + " gold")
		gold_ammount_label.set_text(str(GameInfo.total_gold))
		await excavate_card()

func _on_joker_bought(card: Card) -> void:
	play_this_sound_effect("res://sound/effects/card_bought.mp3")
	add_joker(card)
	original_deck.remove_card_by_value_and_suit(card)
	drawn_cards.erase(card)
	get_parent().set_jokers(jokers)
	get_parent().save_jokers()
	GameInfo.save_game()
	
func add_joker(card: Card) -> void:
	var path: String = "res://scenes/jokers/Joker_" + str(card.card_value) + "_" + str(card.card_suit) + ".tscn"
	var joker_scene = load(path)
	if joker_scene:
		var joker = joker_scene.instantiate()
		if joker:
			for joker_place in jokers.get_children():
				if joker_place.joker == null:
					joker_place.set_joker(joker)
					joker.this_jokers_position = joker.position
					joker.card_value = card.card_value
					joker.card_suit = card.card_suit
					joker.card_path = card.card_path
					joker.connect("mouse_entered_joker", Callable(self, "_on_mouse_entered_joker"))
					joker.connect("mouse_exited_joker", Callable(self, "_on_mouse_exited_joker"))
					joker.connect("joker_sold", Callable(self, "_on_joker_sold"))
					return 
	
func drag_selected_joker(joker: Joker) -> void:
	hide_all_buttons()
	var cursor_texture = load("res://sprites/cursor_dragging.png")
	Input.set_custom_mouse_cursor(cursor_texture)
	joker.get_parent().joker = null
#	joker.get_parent().remove_child(joker)
	current_selected_joker_for_movement = joker
	#current_selected_joker_for_movement_position = current_selected_joker_for_movement.global_position
	is_dragging_a_joker = true
	joker.is_dragging = true
	current_selected_joker_for_movement.z_index = 501  
	
func hide_all_buttons() -> void:
	small_topaz.mouse_filter = Control.MOUSE_FILTER_IGNORE
	small_sapphire.mouse_filter = Control.MOUSE_FILTER_IGNORE
	small_emerald.mouse_filter = Control.MOUSE_FILTER_IGNORE
	small_ruby.mouse_filter = Control.MOUSE_FILTER_IGNORE

	medium_topaz.mouse_filter = Control.MOUSE_FILTER_IGNORE
	medium_sapphire.mouse_filter = Control.MOUSE_FILTER_IGNORE
	medium_emerald.mouse_filter = Control.MOUSE_FILTER_IGNORE
	medium_ruby.mouse_filter = Control.MOUSE_FILTER_IGNORE

	big_topaz.mouse_filter = Control.MOUSE_FILTER_IGNORE
	big_sapphire.mouse_filter = Control.MOUSE_FILTER_IGNORE
	big_emerald.mouse_filter = Control.MOUSE_FILTER_IGNORE
	big_ruby.mouse_filter = Control.MOUSE_FILTER_IGNORE

	next_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	excavate_cards_button.mouse_filter = Control.MOUSE_FILTER_IGNORE

func show_all_buttons() -> void:
	small_topaz.mouse_filter = Control.MOUSE_FILTER_PASS
	small_sapphire.mouse_filter = Control.MOUSE_FILTER_PASS
	small_emerald.mouse_filter = Control.MOUSE_FILTER_PASS
	small_ruby.mouse_filter = Control.MOUSE_FILTER_PASS

	medium_topaz.mouse_filter = Control.MOUSE_FILTER_PASS
	medium_sapphire.mouse_filter = Control.MOUSE_FILTER_PASS
	medium_emerald.mouse_filter = Control.MOUSE_FILTER_PASS
	medium_ruby.mouse_filter = Control.MOUSE_FILTER_PASS

	big_topaz.mouse_filter = Control.MOUSE_FILTER_PASS
	big_sapphire.mouse_filter = Control.MOUSE_FILTER_PASS
	big_emerald.mouse_filter = Control.MOUSE_FILTER_PASS
	big_ruby.mouse_filter = Control.MOUSE_FILTER_PASS

	next_button.mouse_filter = Control.MOUSE_FILTER_PASS
	excavate_cards_button.mouse_filter = Control.MOUSE_FILTER_PASS



func assign_new_position_to_previously_dragged_joker(joker: Joker) -> void:
	show_all_buttons()
	var cursor_texture = load("res://sprites/cursor.png")
	Input.set_custom_mouse_cursor(cursor_texture)
	is_dragging_a_joker = false
	if current_selected_joker_for_movement == null:
		return
	
	for joker_place in jokers.get_children():
		if joker_place.mouse_is_inside_the_joker_place and joker_place.joker == null:
			joker.get_parent().remove_child(joker)
			joker_place.remove_child(joker)
			joker_place.set_joker(joker)
			joker.global_position = joker_place.global_position
			joker.z_index = 1
			return
	
	for joker_place in jokers.get_children():
		if joker_place.joker == null:
			for child in joker_place.get_children():
				if child == joker:
					joker.get_parent().remove_child(joker)
					joker_place.remove_child(joker)
					joker_place.set_joker(joker)
					joker.global_position = joker_place.global_position
					joker.z_index = 1
					return
					
	for joker_place in jokers.get_children():
		if joker_place.joker == null:
			joker.get_parent().remove_child(joker)
			joker_place.remove_child(joker)
			joker_place.set_joker(joker)
			joker.global_position = joker_place.global_position
			joker.z_index = 1
			return
		#current_selected_joker_for_movement.global_position = joker.last_joker_position

func update_jokers_positions():
	if is_dragging_a_joker:
		var position_1: int = jokers.joker_place_1.global_position.x
		var position_2: int = jokers.joker_place_2.global_position.x
		var position_3: int = jokers.joker_place_3.global_position.x
		var position_4: int = jokers.joker_place_4.global_position.x
		var position_5: int = jokers.joker_place_5.global_position.x
		var top_position = jokers.joker_place_1.global_position.y + 50
		var bottom_position = jokers.joker_place_1.global_position.y - 50
		var x = get_global_mouse_position().x
		if get_global_mouse_position().y < top_position and get_global_mouse_position().y > bottom_position:
			if x <= position_1: #less then 1
				move_jokers_to_left_or_right(1, "right")
			if x >= position_1 and x <= (position_1 + position_2)/2 : #more_then 1, less then half
				pass
			if x >= (position_1 + position_2)/2 and x <= position_2: #more then half, less then 2
				move_jokers_to_left_or_right(2, "right")
			if x >= position_2 and x <= (position_2 + position_3)/2 : #more then 2 less then half
				move_jokers_to_left_or_right(2, "left")
			if x >= (position_2 + position_3)/2 and x <= position_3:
				move_jokers_to_left_or_right(3, "right")
			if x >= position_3 and x <= (position_3 + position_4)/2 :
				move_jokers_to_left_or_right(3, "left")
			if x >= (position_3 + position_4)/2 and x <= position_4:
				move_jokers_to_left_or_right(4, "right")
			if x > position_4 and x < (position_4 + position_5)/2 :
				move_jokers_to_left_or_right(4, "left")
			if x >= (position_4 + position_5)/2 and x <= position_5:
				pass
			if x > position_5:
				move_jokers_to_left_or_right(5, "left")
				
func move_jokers_to_left_or_right(starting_joker: int, side: String) -> void:
	if side == "left":
		move_jokers_to_the_left(starting_joker - 1)
	if side == "right":
		move_jokers_to_the_right(starting_joker - 1)

func move_jokers_to_the_left(starting_joker_int):
	var empty_joker_place = null
	var empty_joker_place_int = -1
	
	for j in range(0, jokers.get_child_count()):
		var joker_place = jokers.get_child(j)
		if joker_place.joker == null:
			empty_joker_place = joker_place
			empty_joker_place_int = j
		if j == starting_joker_int:
			if empty_joker_place == null:
				return false
			else:
				for i in range(empty_joker_place_int, starting_joker_int):
					if i + 1 <= starting_joker_int:
						var moving_joker_place = jokers.get_child(i + 1)
						var joker = moving_joker_place.joker
						var new_joker_place = jokers.get_child(i) 
						
						#aniamtion
						#var tween = get_tree().create_tween()
						#tween.tween_property(joker, "global_position:x", new_joker_place.global_position.x, 0.5) \
						#	.set_trans(Tween.TRANS_QUAD) \
						#	.set_ease(Tween.EASE_OUT)
						#await tween.finished
						
						moving_joker_place.remove_child(joker)
						moving_joker_place.joker = null
						new_joker_place.set_joker(joker)
						
	return true


func move_jokers_to_the_right(starting_joker_int: int) -> bool:
	var empty_joker_place = null
	var empty_joker_place_int = -1
	
	for j in range(jokers.get_child_count() - 1, -1, -1):
		var joker_place = jokers.get_child(j)
		if joker_place.joker == null:
			empty_joker_place = joker_place
			empty_joker_place_int = j
		if j == starting_joker_int:
			if empty_joker_place == null:
				return false
			else:
				for i in range(empty_joker_place_int, starting_joker_int - 1, -1):
					if i - 1 >= starting_joker_int:
						var moving_joker_place = jokers.get_child(i - 1)
						var joker = moving_joker_place.joker
						var new_joker_place = jokers.get_child(i) 
						
						moving_joker_place.remove_child(joker)
						moving_joker_place.joker = null
						new_joker_place.set_joker(joker)
						
	return true

func _on_medium_emerald_mouse_entered() -> void:
	get_node("medium_emerald/TextureRect").z_index = -1
	get_node("medium_emerald").set_modulate(Color(1.3, 1.3, 1.3, 1))
	joker_effect_label.set_text("When played, this card plays again with 0 base value.")
	sell_joker_label.set_text("Click to buy for 2 gold.")

func _on_medium_emerald_mouse_exited() -> void:
	get_node("medium_emerald/TextureRect").z_index = 0
	get_node("medium_emerald").set_modulate(Color(1, 1, 1, 1))
	joker_effect_label.set_text("")
	sell_joker_label.set_text("")

func _on_medium_sapphire_mouse_entered() -> void:
	get_node("medium_sapphire/TextureRect").z_index = -1
	get_node("medium_sapphire").set_modulate(Color(1.3, 1.3, 1.3, 1))
	joker_effect_label.set_text("This card can be placed on any card with same suit.")
	sell_joker_label.set_text("Click to buy for 2 gold.")

func _on_medium_sapphire_mouse_exited() -> void:
	get_node("medium_sapphire/TextureRect").z_index = 0
	get_node("medium_sapphire").set_modulate(Color(1, 1, 1, 1))
	joker_effect_label.set_text("")
	sell_joker_label.set_text("")

func _on_medium_ruby_mouse_entered() -> void:
	get_node("medium_ruby/TextureRect").z_index = -1
	get_node("medium_ruby").set_modulate(Color(1.3, 1.3, 1.3, 1))
	joker_effect_label.set_text("This cards base value +10.")
	sell_joker_label.set_text("Click to buy for 2 gold.")

func _on_medium_ruby_mouse_exited() -> void:
	get_node("medium_ruby/TextureRect").z_index = 0
	get_node("medium_ruby").set_modulate(Color(1, 1, 1, 1))
	joker_effect_label.set_text("")
	sell_joker_label.set_text("")

func _on_medium_topaz_mouse_entered() -> void:
	get_node("medium_topaz/TextureRect").z_index = -1
	get_node("medium_topaz").set_modulate(Color(1.3, 1.3, 1.3, 1))
	joker_effect_label.set_text("This card can't be locked, when played stun opponent.")
	sell_joker_label.set_text("Click to buy for 2 gold.")

func _on_medium_topaz_mouse_exited() -> void:
	get_node("medium_topaz/TextureRect").z_index = 0
	get_node("medium_topaz").set_modulate(Color(1, 1, 1, 1))
	joker_effect_label.set_text("")
	sell_joker_label.set_text("")

func _on_small_emerald_mouse_entered() -> void:
	get_node("small_emerald/TextureRect").z_index = -1
	get_node("small_emerald").set_modulate(Color(1.3, 1.3, 1.3, 1))
	joker_effect_label.set_text("When played, this card plays again with 0 base value.")
	sell_joker_label.set_text("Click to buy for 1 gold.")

func _on_small_emerald_mouse_exited() -> void:
	get_node("small_emerald/TextureRect").z_index = 0
	get_node("small_emerald").set_modulate(Color(1, 1, 1, 1))
	joker_effect_label.set_text("")
	sell_joker_label.set_text("")

func _on_small_topaz_mouse_entered() -> void:
	get_node("small_topaz/TextureRect").z_index = -1
	get_node("small_topaz").set_modulate(Color(1.3, 1.3, 1.3, 1))
	joker_effect_label.set_text("This card can't be locked, when played stun opponent.")
	sell_joker_label.set_text("Click to buy for 1 gold.")

func _on_small_topaz_mouse_exited() -> void:
	get_node("small_topaz/TextureRect").z_index = 0
	get_node("small_topaz").set_modulate(Color(1, 1, 1, 1))
	joker_effect_label.set_text("")
	sell_joker_label.set_text("")

func _on_small_sapphire_mouse_entered() -> void:
	get_node("small_sapphire/TextureRect").z_index = -1
	get_node("small_sapphire").set_modulate(Color(1.3, 1.3, 1.3, 1))
	joker_effect_label.set_text("This card can be placed on any card with same suit.")
	sell_joker_label.set_text("Click to buy for 1 gold.")

func _on_small_sapphire_mouse_exited() -> void:
	get_node("small_sapphire/TextureRect").z_index = 0
	get_node("small_sapphire").set_modulate(Color(1, 1, 1, 1))
	joker_effect_label.set_text("")
	sell_joker_label.set_text("")

func _on_small_ruby_mouse_entered() -> void:
	get_node("small_ruby/TextureRect").z_index = -1
	get_node("small_ruby").set_modulate(Color(1.3, 1.3, 1.3, 1))
	joker_effect_label.set_text("This cards base value +10.")
	sell_joker_label.set_text("Click to buy for 1 gold.")

func _on_small_ruby_mouse_exited() -> void:
	get_node("small_ruby/TextureRect").z_index = 0
	get_node("small_ruby").set_modulate(Color(1, 1, 1, 1))
	joker_effect_label.set_text("")
	sell_joker_label.set_text("")

func _on_big_emerald_mouse_entered() -> void:
	get_node("big_emerald/TextureRect").z_index = -1
	get_node("big_emerald").set_modulate(Color(1.3, 1.3, 1.3, 1))
	joker_effect_label.set_text("When played, this card plays again with 0 base value.")
	sell_joker_label.set_text("Click to buy for 5 gold.")

func _on_big_emerald_mouse_exited() -> void:
	get_node("big_emerald/TextureRect").z_index = 0
	get_node("big_emerald").set_modulate(Color(1, 1, 1, 1))
	joker_effect_label.set_text("")
	sell_joker_label.set_text("")

func _on_big_topaz_mouse_entered() -> void:
	get_node("big_topaz/TextureRect").z_index = -1
	get_node("big_topaz").set_modulate(Color(1.3, 1.3, 1.3, 1))
	joker_effect_label.set_text("This card can't be locked, when played stun opponent.")
	sell_joker_label.set_text("Click to buy for 5 gold.")

func _on_big_topaz_mouse_exited() -> void:
	get_node("big_topaz/TextureRect").z_index = 0
	get_node("big_topaz").set_modulate(Color(1, 1, 1, 1))
	joker_effect_label.set_text("")
	sell_joker_label.set_text("")

func _on_big_sapphire_mouse_entered() -> void:
	get_node("big_sapphire/TextureRect").z_index = -1
	get_node("big_sapphire").set_modulate(Color(1.3, 1.3, 1.3, 1))
	joker_effect_label.set_text("This card can be placed on any card with same suit.")
	sell_joker_label.set_text("Click to buy for 5 gold.")

func _on_big_sapphire_mouse_exited() -> void:
	get_node("big_sapphire/TextureRect").z_index = 0
	get_node("big_sapphire").set_modulate(Color(1, 1, 1, 1))
	joker_effect_label.set_text("")
	sell_joker_label.set_text("")

func _on_big_ruby_mouse_entered() -> void:
	get_node("big_ruby/TextureRect").z_index = -1
	get_node("big_ruby").set_modulate(Color(1.3, 1.3, 1.3, 1))
	joker_effect_label.set_text("This cards base value +10.")
	sell_joker_label.set_text("Click to buy for 5 gold.")

func _on_big_ruby_mouse_exited() -> void:
	get_node("big_ruby/TextureRect").z_index = 0
	get_node("big_ruby").set_modulate(Color(1, 1, 1, 1))
	joker_effect_label.set_text("")
	sell_joker_label.set_text("")

func _on_medium_topaz_pressed() -> void:
	if GameInfo.total_gold >= 2:
		play_this_sound_effect("res://sound/effects/gem_sound.mp3")
		GameInfo.total_gold -= 2
		gold_ammount_label.set_text(str(GameInfo.total_gold))
		topaz_touch = true
		var new_cursor_texture = load("res://sprites/cursor_topaz.png")
		Input.set_custom_mouse_cursor(new_cursor_texture)
		medium_topaz.global_position = Vector2(-100,-100)
		_on_medium_topaz_mouse_exited()
		sell_joker_label.set_text("Next card you click will become topaz.")
	else:
		sell_joker_label.set_text("Not enough gold.")
func _on_medium_ruby_pressed() -> void:
	if GameInfo.total_gold >= 2:
		play_this_sound_effect("res://sound/effects/gem_sound.mp3")
		GameInfo.total_gold -= 2
		gold_ammount_label.set_text(str(GameInfo.total_gold))
		ruby_touch = true
		var new_cursor_texture = load("res://sprites/cursor_ruby.png")
		Input.set_custom_mouse_cursor(new_cursor_texture)
		medium_ruby.global_position = Vector2(-100,-100)
		_on_medium_ruby_mouse_exited()
		sell_joker_label.set_text("Next card you click will become ruby.")
	else:
		sell_joker_label.set_text("Not enough gold.")
func _on_medium_sapphire_pressed() -> void:
	if GameInfo.total_gold >= 2:
		play_this_sound_effect("res://sound/effects/gem_sound.mp3")
		GameInfo.total_gold -= 2
		gold_ammount_label.set_text(str(GameInfo.total_gold))
		sapphire_touch = true
		var new_cursor_texture = load("res://sprites/cursor_sapphire.png")
		Input.set_custom_mouse_cursor(new_cursor_texture)
		medium_sapphire.global_position = Vector2(-100,-100)
		_on_medium_sapphire_mouse_exited()
		sell_joker_label.set_text("Next card you click will become sapphire.")
	else:
		sell_joker_label.set_text("Not enough gold.")
func _on_medium_emerald_pressed() -> void:
	if GameInfo.total_gold >= 2:
		play_this_sound_effect("res://sound/effects/gem_sound.mp3")
		GameInfo.total_gold -= 2
		gold_ammount_label.set_text(str(GameInfo.total_gold))
		emerald_touch = true
		var new_cursor_texture = load("res://sprites/cursor_emerald.png")
		Input.set_custom_mouse_cursor(new_cursor_texture)
		medium_emerald.global_position = Vector2(-100,-100)
		_on_medium_emerald_mouse_exited()
		sell_joker_label.set_text("Next card you click will become emerald.")
	else:
		sell_joker_label.set_text("Not enough gold.")
func _on_small_emerald_pressed() -> void:
	if GameInfo.total_gold >= 1:
		play_this_sound_effect("res://sound/effects/gem_sound.mp3")
		GameInfo.total_gold -= 1
		gold_ammount_label.set_text(str(GameInfo.total_gold))
		if drawn_cards.size() != 0:
			var random_card = drawn_cards.pick_random()
			random_card.highlight_emerald_card()
			random_card.topaz = false
			random_card.emerald = true
			random_card.ruby = false
			random_card.sapphire = false
			var card_name = random_card.card_suit + '_' + str(random_card.card_value)
			GameInfo.set(card_name, "emerald")
		small_emerald.global_position = Vector2(-100,-100)
		_on_small_emerald_mouse_exited()
	else:
		sell_joker_label.set_text("Not enough gold.")
func _on_small_topaz_pressed() -> void:
	if GameInfo.total_gold >= 1:
		play_this_sound_effect("res://sound/effects/gem_sound.mp3")
		GameInfo.total_gold -= 1
		gold_ammount_label.set_text(str(GameInfo.total_gold))
		if drawn_cards.size() != 0:
			var random_card = drawn_cards.pick_random()
			random_card.highlight_topaz_card()
			random_card.topaz = true
			random_card.emerald = false
			random_card.ruby = false
			random_card.sapphire = false
			var card_name = random_card.card_suit + '_' + str(random_card.card_value)
			GameInfo.set(card_name, "topaz")
		small_topaz.global_position = Vector2(-100,-100)
		_on_small_topaz_mouse_exited()
	else:
		sell_joker_label.set_text("Not enough gold.")
func _on_small_sapphire_pressed() -> void:
	if GameInfo.total_gold >= 1:
		play_this_sound_effect("res://sound/effects/gem_sound.mp3")
		GameInfo.total_gold -= 1
		gold_ammount_label.set_text(str(GameInfo.total_gold))
		if drawn_cards.size() != 0:
			var random_card = drawn_cards.pick_random()
			random_card.highlight_sapphire_card()
			random_card.topaz = false
			random_card.emerald = false
			random_card.ruby = false
			random_card.sapphire = true
			var card_name = random_card.card_suit + '_' + str(random_card.card_value)
			GameInfo.set(card_name, "sapphire")
		small_sapphire.global_position = Vector2(-100,-100)
		_on_small_sapphire_mouse_exited()
	else:
		sell_joker_label.set_text("Not enough gold.")
func _on_small_ruby_pressed() -> void:
	if GameInfo.total_gold >= 1:
		play_this_sound_effect("res://sound/effects/gem_sound.mp3")
		GameInfo.total_gold -= 1
		gold_ammount_label.set_text(str(GameInfo.total_gold))
		if drawn_cards.size() != 0:
			var random_card = drawn_cards.pick_random()
			random_card.highlight_ruby_card()
			random_card.topaz = false
			random_card.emerald = false
			random_card.ruby = true
			random_card.sapphire = false
			var card_name = random_card.card_suit + '_' + str(random_card.card_value)
			GameInfo.set(card_name, "ruby")
		small_ruby.global_position = Vector2(-100,-100)
		_on_small_ruby_mouse_exited()
	else:
		sell_joker_label.set_text("Not enough gold.")
func _on_big_emerald_pressed() -> void:
	if GameInfo.total_gold >= 5:
		play_this_sound_effect("res://sound/effects/gem_sound.mp3")
		GameInfo.total_gold -= 5
		gold_ammount_label.set_text(str(GameInfo.total_gold))
		for card in drawn_cards:
			card.highlight_emerald_card()
			card.topaz = false
			card.emerald = true
			card.ruby = false
			card.sapphire = false
			var card_name = card.card_suit + '_' + str(card.card_value)
			GameInfo.set(card_name, "emerald")
		big_emerald.global_position = Vector2(-100,-100)
		_on_big_emerald_mouse_exited()
	else:
		sell_joker_label.set_text("Not enough gold.")
func _on_big_topaz_pressed() -> void:
	if GameInfo.total_gold >= 5:
		play_this_sound_effect("res://sound/effects/gem_sound.mp3")
		GameInfo.total_gold -= 5
		gold_ammount_label.set_text(str(GameInfo.total_gold))
		for card in drawn_cards:
			card.highlight_topaz_card()
			card.topaz = true
			card.emerald = false
			card.ruby = false
			card.sapphire = false
			var card_name = card.card_suit + '_' + str(card.card_value)
			GameInfo.set(card_name, "topaz")
		big_topaz.global_position = Vector2(-100,-100)
		_on_big_topaz_mouse_exited()
	else:
		sell_joker_label.set_text("Not enough gold.")
func _on_big_sapphire_pressed() -> void:
	if GameInfo.total_gold >= 5:
		play_this_sound_effect("res://sound/effects/gem_sound.mp3")
		GameInfo.total_gold -= 5
		gold_ammount_label.set_text(str(GameInfo.total_gold))
		for card in drawn_cards:
			card.highlight_sapphire_card()
			card.topaz = false
			card.emerald = false
			card.ruby = false
			card.sapphire = true
			var card_name = card.card_suit + '_' + str(card.card_value)
			GameInfo.set(card_name, "sapphire")
		big_sapphire.global_position = Vector2(-100,-100)
		_on_big_sapphire_mouse_exited()
	else:
		sell_joker_label.set_text("Not enough gold.")
func _on_big_ruby_pressed() -> void:
	if GameInfo.total_gold >= 5:
		play_this_sound_effect("res://sound/effects/gem_sound.mp3")
		GameInfo.total_gold -= 5
		gold_ammount_label.set_text(str(GameInfo.total_gold))
		for card in drawn_cards:
			card.highlight_ruby_card()
			card.topaz = false
			card.emerald = false
			card.ruby = true
			card.sapphire = false
			var card_name = card.card_suit + '_' + str(card.card_value)
			GameInfo.set(card_name, "ruby")
		big_ruby.global_position = Vector2(-100,-100)
		_on_big_ruby_mouse_exited()
	else:
		sell_joker_label.set_text("Not enough gold.")


func _on_next_button_mouse_entered() -> void:
	desk.hide()
	desk_next_button_bigger.show()

func _on_next_button_mouse_exited() -> void:
	desk.show()
	desk_next_button_bigger.hide()

func _on_excavate_mouse_entered() -> void:
	desk.hide()
	desk_excavate_button_bigger.show()

func _on_excavate_mouse_exited() -> void:
	desk.show()
	desk_excavate_button_bigger.hide()

func play_this_sound_effect(path: String) -> void:
	if path.is_empty():
		return
	var audio_stream = load(path)
	if audio_stream is AudioStream:
		soundfx_player.stream = audio_stream
		soundfx_player.play()
	else:
		push_warning("Invalid audio stream at path: " + path)

func set_jokers(jokers_parent: Node) -> void:
	if jokers_parent:
		for i in range(0,5):
			if jokers_parent.get_child(i).joker != null:
				var joker = jokers_parent.get_child(i).joker.duplicate(DUPLICATE_SCRIPTS | DUPLICATE_GROUPS | DUPLICATE_SIGNALS)
				joker.connect("mouse_entered_joker", Callable(self, "_on_mouse_entered_joker"))
				joker.connect("mouse_exited_joker", Callable(self, "_on_mouse_exited_joker"))
				joker.connect("joker_sold", Callable(self, "_on_joker_sold"))
				jokers.get_child(i).set_joker(joker)
