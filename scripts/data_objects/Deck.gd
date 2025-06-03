class_name Deck extends Resource

var card_collection: Dictionary = {}
var id_counter: int = 0

var card_scene: PackedScene = preload("res://scenes/card.tscn")

func add_card(card: Card):
	var card_id = _generate_card_id()
	card_collection[card_id] = card 
	id_counter += 1
	
func remove_card(card_id: int):
	card_collection.erase(card_id)

func remove_card_by_value(card: Card):
	for key in card_collection:
		if card_collection[key] == card:
			remove_card(key)

func remove_card_by_value_and_suit(card: Card):
	for key in card_collection:
		if card_collection[key].card_value == card.card_value and card_collection[key].card_suit == card.card_suit:
			remove_card(key)
			card.queue_free()

func get_keys() -> Array:
	var keys = []
	for key in card_collection: 
		keys.append(key)
	return keys
	
func update_card(card_id: int, card: Card):
	card_collection[card_id] = card

func _generate_card_id():
	return id_counter
	
func get_card(card_id: int) -> Card:
	if card_collection.has(card_id):
		return card_collection[card_id]
	else:
		return null


func find_this_card(value: int, suit: String) -> Card:
	for card_id in card_collection.keys():
		var card = card_collection[card_id]
		if card.card_value == value and card.card_suit == suit:
			return card
	return null

func add_card_to_deck(suit: String, value: int, path: String):
	var card: Card = card_scene.instantiate()
	card.set_card_value(value)
	card.set_card_suit(suit)
	card.set_card_path(path)
	add_card(card)
	
func initialize_deck():
	card_collection.clear()
	add_card_to_deck("spades", 1, "res://sprites/card_sprites/1_spades.png")
	add_card_to_deck("spades", 2, "res://sprites/card_sprites/2_spades.png")
	add_card_to_deck("spades", 3, "res://sprites/card_sprites/3_spades.png")
	add_card_to_deck("spades", 4, "res://sprites/card_sprites/4_spades.png")
	add_card_to_deck("spades", 5, "res://sprites/card_sprites/5_spades.png")
	add_card_to_deck("spades", 6, "res://sprites/card_sprites/6_spades.png")
	add_card_to_deck("spades", 7, "res://sprites/card_sprites/7_spades.png")
	add_card_to_deck("spades", 8, "res://sprites/card_sprites/8_spades.png")
	add_card_to_deck("spades", 9, "res://sprites/card_sprites/9_spades.png")
	add_card_to_deck("spades", 10, "res://sprites/card_sprites/10_spades.png")
	add_card_to_deck("spades", 11, "res://sprites/card_sprites/j_spades.png")
	add_card_to_deck("spades", 12, "res://sprites/card_sprites/q_spades.png")
	add_card_to_deck("spades", 13, "res://sprites/card_sprites/k_spades.png")
	
	add_card_to_deck("diamonds", 1,  "res://sprites/card_sprites/1_diamonds.png")
	add_card_to_deck("diamonds", 2, "res://sprites/card_sprites/2_diamonds.png")
	add_card_to_deck("diamonds", 3, "res://sprites/card_sprites/3_diamonds.png")
	add_card_to_deck("diamonds", 4, "res://sprites/card_sprites/4_diamonds.png")
	add_card_to_deck("diamonds", 5, "res://sprites/card_sprites/5_diamonds.png")
	add_card_to_deck("diamonds", 6, "res://sprites/card_sprites/6_diamonds.png")
	add_card_to_deck("diamonds", 7, "res://sprites/card_sprites/7_diamonds.png")
	add_card_to_deck("diamonds", 8, "res://sprites/card_sprites/8_diamonds.png")
	add_card_to_deck("diamonds", 9, "res://sprites/card_sprites/9_diamonds.png")
	add_card_to_deck("diamonds", 10, "res://sprites/card_sprites/10_diamonds.png")
	add_card_to_deck("diamonds", 11, "res://sprites/card_sprites/j_diamonds.png")
	add_card_to_deck("diamonds", 12, "res://sprites/card_sprites/q_diamonds.png")
	add_card_to_deck("diamonds", 13, "res://sprites/card_sprites/k_diamonds.png")
	
	add_card_to_deck("clubs", 1, "res://sprites/card_sprites/1_clubs.png")
	add_card_to_deck("clubs", 2, "res://sprites/card_sprites/2_clubs.png")
	add_card_to_deck("clubs", 3, "res://sprites/card_sprites/3_clubs.png")
	add_card_to_deck("clubs", 4, "res://sprites/card_sprites/4_clubs.png")
	add_card_to_deck("clubs", 5, "res://sprites/card_sprites/5_clubs.png")
	add_card_to_deck("clubs", 6, "res://sprites/card_sprites/6_clubs.png")
	add_card_to_deck("clubs", 7, "res://sprites/card_sprites/7_clubs.png")
	add_card_to_deck("clubs", 8, "res://sprites/card_sprites/8_clubs.png")
	add_card_to_deck("clubs", 9, "res://sprites/card_sprites/9_clubs.png")
	add_card_to_deck("clubs", 10, "res://sprites/card_sprites/10_clubs.png")
	add_card_to_deck("clubs", 11, "res://sprites/card_sprites/j_clubs.png")
	add_card_to_deck("clubs", 12, "res://sprites/card_sprites/q_clubs.png")
	add_card_to_deck("clubs", 13, "res://sprites/card_sprites/k_clubs.png")

	add_card_to_deck("hearts", 1, "res://sprites/card_sprites/1_hearts.png")
	add_card_to_deck("hearts", 2, "res://sprites/card_sprites/2_hearts.png")
	add_card_to_deck("hearts", 3, "res://sprites/card_sprites/3_hearts.png")
	add_card_to_deck("hearts", 4, "res://sprites/card_sprites/4_hearts.png")
	add_card_to_deck("hearts", 5, "res://sprites/card_sprites/5_hearts.png")
	add_card_to_deck("hearts", 6, "res://sprites/card_sprites/6_hearts.png")
	add_card_to_deck("hearts", 7, "res://sprites/card_sprites/7_hearts.png")
	add_card_to_deck("hearts", 8, "res://sprites/card_sprites/8_hearts.png" )
	add_card_to_deck("hearts", 9, "res://sprites/card_sprites/9_hearts.png")
	add_card_to_deck("hearts", 10, "res://sprites/card_sprites/10_hearts.png")
	add_card_to_deck("hearts", 11, "res://sprites/card_sprites/j_hearts.png")
	add_card_to_deck("hearts", 12, "res://sprites/card_sprites/q_hearts.png")
	add_card_to_deck("hearts", 13, "res://sprites/card_sprites/k_hearts.png")
