class_name Shop extends Node2D

@onready var spawnpoints = $spawnpoints.get_children() 
var drawn_cards = []
var original_deck: Deck = null
@onready var desk: Sprite2D = $desk
@onready var jokers = $Jokers
@onready var joker_effect_label = $ColorRect/joker_effect_label
@onready var gold_ammount_label = $gold_ammount_label

signal show_board

var main: Main 
	
func set_deck(deck: Deck) -> void:
	original_deck = deck
	
func get_random_card_from_deck() -> Card:
	if get_parent() and original_deck and original_deck.card_collection.size() > 0:
		var random_index = randi() % get_parent().original_deck.card_collection.size()
		return original_deck.card_collection[random_index].duplicate()
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
				var joker_position_path = "joker_place_" + str(jokers.get_child_count() - 1)
				var position_node = jokers.get_node("places").get_node(joker_position_path)
				if position_node:
					new_joker.position = position_node.position
				new_joker.connect("mouse_entered_joker", Callable(self, "_on_mouse_entered_joker"))
				new_joker.connect("mouse_exited_joker", Callable(self, "_on_mouse_exited_joker"))
				
func _on_mouse_entered_joker(joker: Joker) -> void:
	if joker.has_node("effect"):
		var child = joker.get_node("effect")
		joker_effect_label.text = str(child.joker_effect)
	
func _on_mouse_exited_joker() -> void:
	joker_effect_label.text = "Hower a card to see its joker effect"
	
func _ready() -> void:
	
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
	emit_signal("show_board") 
	hide()  

func _on_exacuviate_pressed() -> void:
	excavate_card()


func _input(event):
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		pass
		
func _on_joker_bought(card: Card) -> void:
	get_parent().add_joker(card)
	add_joker(card)
	original_deck.remove_card_by_value_and_suit(card)
	get_parent().original_deck = original_deck
	drawn_cards.erase(card)


func add_joker(card: Card) -> void:
	var path: String = "res://scenes/jokers/Joker_" + str(card.card_value) + "_" + str(card.card_suit) + ".tscn"
	var joker_scene = load(path)
	if joker_scene:
		var joker = joker_scene.instantiate()
		if joker:
			jokers.add_child(joker)
			var joker_position_path: String = "joker_place_" + str(jokers.get_child_count() - 1)
			joker.position = jokers.get_node("places").get_node(joker_position_path).position	
			joker.card_value = card.card_value
			joker.card_suit = card.card_suit
			joker.card_path = card.card_path
			joker.connect("mouse_entered_joker", Callable(self, "_on_mouse_entered_joker"))
			joker.connect("mouse_exited_joker", Callable(self, "_on_mouse_exited_joker"))
