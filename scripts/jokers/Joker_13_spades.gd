class_name Joker_13_spades extends Node

var joker_effect = "When you play 3 spades add 40 to the score."
var joker_price: int = 5

var activation_window: String = 'on_card_played'
var suit_counter: int = 3

func activate(_activation_window: String, deck: Deck, ui: Ui, card: Card):
	
	if activation_window == _activation_window:
		if card.card_suit == 'spades':
			suit_counter -= 1
			if suit_counter == 0:
				suit_counter = 3
				highlight()
				ui.get_parent().enemy.set_visual_aid_label('+40')
				await get_tree().create_timer(0.3).timeout
				ui.get_parent().enemy.set_visual_aid_label('')
				ui.get_parent().enemy.set_score_value(ui.get_parent().enemy.score + 40)
				await get_tree().create_timer(1).timeout
			
	
func highlight():
	$"../Sprite2D".set_modulate(Color(1,0.1,0.2,1))
	await get_tree().create_timer(0.5).timeout
	$"../Sprite2D".set_modulate(Color(1,1,1,1))
