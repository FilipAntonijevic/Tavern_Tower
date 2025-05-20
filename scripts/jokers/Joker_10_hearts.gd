class_name Joker_10_hearts extends Node

var joker_effect = "When you play a ruby card add 20 to the score."
var joker_price: int = 3

var activation_window: String = 'on_card_played'
var array_of_possible_equal_numbers: Array = [1,2,3,4,5,6,7,8,9,10,11,12,13]
func activate(_activation_window: String, deck: Deck, ui: Ui, _card: Card):
	if activation_window == _activation_window:
		if _card.ruby:
			highlight()
			ui.get_parent().enemy.set_visual_aid_label('+20')
			await get_tree().create_timer(0.3).timeout
			ui.get_parent().enemy.set_visual_aid_label('')
			ui.get_parent().enemy.set_score_value(ui.get_parent().enemy.score + 20)
			await get_tree().create_timer(1).timeout

func highlight():
	$"../Sprite2D".set_modulate(Color(1,0.1,0.2,1))
	await get_tree().create_timer(0.5).timeout
	$"../Sprite2D".set_modulate(Color(1,1,1,1))
