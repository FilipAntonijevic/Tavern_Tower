class_name Joker_11_clubs extends Node

var joker_effect = "When you play consecative cards of same suit add 10 to the score."
var joker_price: int = 5

var activation_window: String = 'on_card_played'
var last_suit_played: String = 'null'

func activate(_activation_window: String, deck: Deck, ui: Ui, _card: Card):
	
	if activation_window == _activation_window:
		if last_suit_played == _card.card_suit:
			highlight()
			ui.get_parent().enemy.set_visual_aid_label('+10')
			await get_tree().create_timer(0.3).timeout
			ui.get_parent().enemy.set_visual_aid_label('')
			ui.get_parent().enemy.set_score_value(ui.get_parent().enemy.score + 10)
			await get_tree().create_timer(1).timeout
		else:
			last_suit_played = _card.card_suit
		

func highlight():
	$"../Sprite2D".set_modulate(Color(1,0.1,0.2,1))
	await get_tree().create_timer(0.5).timeout
	$"../Sprite2D".set_modulate(Color(1,1,1,1))
