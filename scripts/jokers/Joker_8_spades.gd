class_name Joker_8_spades extends Node2D

var joker_effect = "When played, add 15 to the score for each of your jokers."
var joker_price: int = 4

var activation_window = 'on_this_card_played'
func activate(_activation_window: String, deck: Deck, ui: Ui, _card: Card):
	var i = 0
	if activation_window == _activation_window:
		if _card.card_suit == "spades" and _card.card_value == 8:
			for joker_place in ui.get_parent().jokers.get_children():
				if joker_place.joker != null:
					i += 1
			var new_score = 15 * i
			ui.get_parent().enemy.set_visual_aid_label('+'+ str(new_score))
			highlight()
			await get_tree().create_timer(0.3).timeout
			ui.get_parent().enemy.set_visual_aid_label('')
			ui.get_parent().enemy.set_score_value(ui.get_parent().enemy.score + new_score)
			await get_tree().create_timer(1).timeout
	
	
func highlight():
	$"../Sprite2D".set_modulate(Color(1,0.1,0.2,1))
	await get_tree().create_timer(0.5).timeout
	$"../Sprite2D".set_modulate(Color(1,1,1,1))
