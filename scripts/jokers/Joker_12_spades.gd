class_name Joker_12_spades extends Node

var joker_effect = "When you play a spade, x3 the score."
var joker_price: int = 6

var activation_window: String = 'on_card_played'

func activate(_activation_window: String, deck: Deck, ui: Ui, _card: Card):
	if activation_window == _activation_window:
		if _card.card_suit == 'spades' and _card.card_value < 12:
			highlight()
			ui.get_parent().enemy.set_visual_aid_label('x3')
			await get_tree().create_timer(0.3).timeout
			ui.get_parent().enemy.set_visual_aid_label('')
			ui.get_parent().enemy.set_score_value(ui.get_parent().enemy.score * 3)
			await get_tree().create_timer(1).timeout
			

func highlight():
	$"../Sprite2D".set_modulate(Color(1,0.1,0.2,1))
	await get_tree().create_timer(1).timeout
	$"../Sprite2D".set_modulate(Color(1,1,1,1))
