class_name Joker_10_diamonds extends Node

var joker_effect = "When you play a topaz card add 20 to the score."
var joker_price: int = 3

var activation_window: String = 'on_card_played'

func activate(_activation_window: String, deck: Deck, ui: Ui, _card: Card):
	if activation_window == _activation_window:
		if _card.topaz:
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
