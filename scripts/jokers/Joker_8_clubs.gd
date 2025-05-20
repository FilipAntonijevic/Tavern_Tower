class_name Joker_8_clubs extends Node2D

var joker_effect = "If all your jokers are same suit, gain 4g when you play this card."
var joker_price: int = 2

var activation_window = 'on_this_card_played'
func activate(_activation_window: String, deck: Deck, ui: Ui, _card: Card):
	var joker_suit: String = ""
	var all_jokers_are_same_suit: bool = true
	if activation_window == _activation_window:
		if _card.card_suit == "clubs" and _card.card_value == 8:
			for joker_place in ui.get_parent().jokers.get_children():
				if joker_place.joker != null:
					var joker_class_name = joker_place.joker.effect.get_script().resource_path.get_file().get_basename()
					var parts = joker_class_name.split("_") 
					var new_joker_suit = parts[-1]
					print(new_joker_suit)
					if joker_suit == "":
						joker_suit = new_joker_suit
					if joker_suit != new_joker_suit:
						all_jokers_are_same_suit = false
						break
			if all_jokers_are_same_suit:
				highlight()
				ui.get_parent().update_coins(ui.get_parent().enemy_gold + 4)
				
func highlight():
	$"../Sprite2D".set_modulate(Color(1,0.1,0.2,1))
	await get_tree().create_timer(0.5).timeout
	$"../Sprite2D".set_modulate(Color(1,1,1,1))
