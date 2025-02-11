class_name Shop extends Node2D

@onready var card_scene: PackedScene = preload("res://scenes/card.tscn")
@onready var spawnpoints = $spawnpoints.get_children() 
var drawn_cards = []
var original_deck: Deck = null
@onready var desk: Sprite2D = $desk
@onready var jokers = $Jokers
@onready var joker_effect_label = $joker_effect_label
@onready var sell_joker_label = $sell_joker_label
@onready var gold_ammount_label = $gold_ammount_label
@onready var excavation_cost_label = $desk/excavation_cost_label

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
		var random_index = randi() % get_parent().original_deck.card_collection.size()
		if original_deck.card_collection.has(random_index):
			return original_deck.card_collection[random_index]
		else:
			return get_random_card_from_deck()
	else:
		return null

		
func excavate_card() -> void:
	
	var card = get_random_card_from_deck()
	if check_if_card_can_be_excavated(card): 
		drawn_cards.append(card)  
		
		for card_place in spawnpoints:
			if !card_place.has_node("Card"):
				card_place.set_card(card)
				card.set_card_sprite(card.card_path)
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
	var main_jokers = get_tree().get_root().get_node("Main").jokers
	if main_jokers:
		for joker in main_jokers.get_children():
			if joker.name != "places": 
				var new_joker = joker.duplicate()
				jokers.add_child(new_joker)
				new_joker.position = jokers.jokers_positions[jokers.get_child_count() - 2]
				new_joker.this_jokers_position = new_joker.position
				new_joker.connect("mouse_entered_joker", Callable(self, "_on_mouse_entered_joker"))
				new_joker.connect("mouse_exited_joker", Callable(self, "_on_mouse_exited_joker"))
				new_joker.connect("joker_sold", Callable(self, "_on_joker_sold"))

func _on_mouse_entered_joker(joker: Joker) -> void:
	if joker.has_node("effect"):
		var child = joker.get_node("effect")
		joker_effect_label.text = str(child.joker_effect)
		var sell_value: int = int(joker.effect.joker_price / 2)
		if sell_value == 1:
			sell_joker_label.set_text("Right click to sell for: " + str(sell_value) + " coin")
		else:
			sell_joker_label.set_text("Right click to sell for: " + str(sell_value) + " coins")

	
func _on_mouse_exited_joker() -> void:
	joker_effect_label.text = "Hower a card to see its joker effect"
	sell_joker_label.set_text('')

func _on_joker_sold(joker: Joker) -> void:
	jokers.remove_child(joker)
	var card = turn_joker_into_a_card(joker)
	original_deck.add_card(card)
	get_parent().total_gold += int(joker.effect.joker_price / 2)
	gold_ammount_label.set_text(str(get_parent().total_gold))

func turn_joker_into_a_card(joker: Joker) -> Card:
	var card: Card = card_scene.instantiate()
	card.set_card_value(joker.card_value)
	card.set_card_suit(joker.card_suit)
	card.set_card_path(joker.card_path)

	return card
func _ready() -> void:
	
	excavation_cost = 1
	excavation_cost_label.set_text(str(excavation_cost))
		
	joker_effect_label.z_index = 100
	load_jokers()
	
	gold_ammount_label.set_text(str(get_parent().total_gold))
	for card_place in spawnpoints:
		card_place.connect("joker_bought", Callable(self, "_on_joker_bought"))
	
	var timer1 = Timer.new()
	timer1.wait_time = 0.1
	add_child(timer1)
	timer1.start()
	await timer1.timeout
	excavate_card()
	timer1.start()
	await timer1.timeout
	excavate_card()
	timer1.start()
	await timer1.timeout
	excavate_card()
	timer1.queue_free()	
	#excavate_cards(5)


func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_parent().original_deck = copy_deck()
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
	if excavation_cost <= get_parent().total_gold:
		get_parent().total_gold -= excavation_cost
		excavation_cost *= 2
		excavation_cost_label.set_text(str(excavation_cost))
		gold_ammount_label.set_text(str(get_parent().total_gold))
		excavate_card()


func _input(event):
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		pass


func _on_joker_bought(card: Card) -> void:
	get_parent().add_joker(card)
	add_joker(card)
	original_deck.remove_card_by_value_and_suit(card)
	drawn_cards.erase(card)


func add_joker(card: Card) -> void:
	var path: String = "res://scenes/jokers/Joker_" + str(card.card_value) + "_" + str(card.card_suit) + ".tscn"
	var joker_scene = load(path)
	if joker_scene:
		var joker = joker_scene.instantiate()
		if joker:
			jokers.add_child(joker)
			if jokers.get_child_count() <= 6:
				joker.position = jokers.jokers_positions[jokers.get_child_count() - 2]
				joker.this_jokers_position = joker.position
				joker.card_value = card.card_value
				joker.card_suit = card.card_suit
				joker.card_path = card.card_path
				joker.connect("mouse_entered_joker", Callable(self, "_on_mouse_entered_joker"))
				joker.connect("mouse_exited_joker", Callable(self, "_on_mouse_exited_joker"))
				joker.connect("joker_sold", Callable(self, "_on_joker_sold"))

func _on_topaz_pressed() -> void:
	topaz_touch = true

func _on_ruby_pressed() -> void:
	ruby_touch = true

func _on_sapphire_pressed() -> void:
	sapphire_touch = true

func _on_emerald_pressed() -> void:
	emerald_touch = true

func drag_selected_joker(joker: Joker) -> void:
	
	current_selected_joker_for_movement = joker
	#current_selected_joker_for_movement_position = current_selected_joker_for_movement.global_position
	is_dragging_a_joker = true
	joker.is_dragging = true
	current_selected_joker_for_movement.z_index = 101  

func assign_new_position_to_previously_dragged_joker(joker: Joker) -> void:
	
	if current_selected_joker_for_movement == null:
			return
			
	if check_if_joker_can_be_placed_on_a_joker_palce():
		pass
	else:
		if joker.this_jokers_position:
			joker.position = joker.this_jokers_position
		#current_selected_joker_for_movement.global_position = joker.last_joker_position


func check_if_joker_can_be_placed_on_a_joker_palce() -> bool:
	return false
