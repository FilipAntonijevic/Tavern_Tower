class_name Deck extends Resource

var card_collection: Dictionary = {}
var id_counter: int = 0


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
	return card_collection[card_id]
