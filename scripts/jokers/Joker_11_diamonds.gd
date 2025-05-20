class_name Joker_11_diamonds extends Node

var joker_effect = "When you play spade, club, diamond and a heart card, add 30 to the score."
var joker_price: int = 5

var activation_window: String = 'on_card_played'
var array_of_suits: Array = ['spade', 'diamond', 'club', 'heart']

func activate(_activation_window: String, deck: Deck, ui: Ui, _card: Card):
	
	if activation_window == _activation_window:
		if _card.card_suit == 'spades':
			array_of_suits.erase('spade')
		if _card.card_suit == 'diamonds':
			array_of_suits.erase('diamond')
		if _card.card_suit == 'clubs':
			array_of_suits.erase('club')
		if _card.card_suit == 'hearts':
			array_of_suits.erase('heart')
		if array_of_suits.size() == 0:
			array_of_suits = ['spade', 'diamond', 'club', 'heart']
			ui.get_parent().enemy.set_visual_aid_label('+15')
			highlight()
			await get_tree().create_timer(0.3).timeout
			ui.add_to_score(30)
			ui.get_parent().enemy.set_visual_aid_label('')
			await get_tree().create_timer(1).timeout


func highlight():
	$"../Sprite2D".set_modulate(Color(1,0.1,0.2,1))
	await get_tree().create_timer(0.5).timeout
	$"../Sprite2D".set_modulate(Color(1,1,1,1))
