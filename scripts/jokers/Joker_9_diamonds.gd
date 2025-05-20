class_name Joker_9_diamonds extends Node

var joker_effect = "When you play a gem card, remove its gem and replay it."
var joker_price: int = 3
var highest_replayed_card_value = 0

var activation_window: String = 'on_card_played'

func activate(_activation_window: String, deck: Deck, ui: Ui, _card: Card):
	if activation_window == _activation_window:
		if _card.sapphire or _card.topaz or _card.emerald or _card.ruby:
			if _card.card_value > highest_replayed_card_value:
				_card.sapphire = false
				_card.topaz = false
				_card.emerald = false
				_card.ruby = false
				_card.highlight()
				highest_replayed_card_value += 1 
				ui.add_to_score(_card.card_value)
				if _card.card_suit == 'spades':
					ui.card_piles.current_card_value_on_spades_pile -= 1
				if _card.card_suit == 'diamonds':
					ui.card_piles.current_card_value_on_diamonds_pile -= 1
				if _card.card_suit == 'clubs':
					ui.card_piles.current_card_value_on_clubs_pile -= 1
				if _card.card_suit == 'heart':
					ui.card_piles.current_card_value_on_hearts_pile -= 1
				ui.place_card_on_according_pile(_card)
				highlight()

func highlight():
	$"../Sprite2D".set_modulate(Color(1,0.1,0.2,1))
	await get_tree().create_timer(0.5).timeout
	$"../Sprite2D".set_modulate(Color(1,1,1,1))
