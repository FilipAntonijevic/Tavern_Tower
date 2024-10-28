class_name Deck extends Resource

#var card_collection: Array = ["1S", "2S", "3S", "4S", "5S", "6S", "7S", "8S", "9S", "TS", "JS", "QS", "KS",
#								"1D", "2D", "3D", "4D", "5D", "6D", "7D", "8D", "9D", "TD", "JD", "QD", "KD",
#								"1C", "2C", "3C", "4C", "5C", "6C", "7C", "8C", "9C", "TC", "JC", "QC", "KC",
#								"1H", "2H", "3H", "4H", "5H", "6H", "7H", "8H", "9H", "TH", "JH", "QH", "KH"]

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
