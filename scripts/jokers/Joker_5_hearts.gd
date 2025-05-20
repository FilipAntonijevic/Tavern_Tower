class_name Joker_5_hearts extends Node2D

var joker_effect = "When played, add 20 to the score for each empty pile."
var joker_price: int = 3

var activation_window = 'on_this_card_played'
func activate(_activation_window: String, deck: Deck, ui: Ui, _card: Card):
	if activation_window == _activation_window:
		if _card.card_suit == "hearts" and _card.card_value == 5:
			var new_score = 0
			if ui.card_piles.current_card_value_on_diamonds_pile == 0:
				new_score += 20
			if ui.card_piles.current_card_value_on_clubs_pile == 0:
				new_score += 20
			if ui.card_piles.current_card_value_on_spades_pile == 0:
				new_score += 20
			ui.get_parent().enemy.set_visual_aid_label('+' + str(new_score))
			await Engine.get_main_loop().create_timer(0.3).timeout
			ui.get_parent().enemy.set_visual_aid_label('')
			ui.get_parent().enemy.set_score_value(ui.get_parent().enemy.score + new_score)
			await Engine.get_main_loop().create_timer(0.3).timeout
	
			
func highlight():
	$"../Sprite2D".set_modulate(Color(1,0.1,0.2,1))
	await get_tree().create_timer(0.5).timeout
	$"../Sprite2D".set_modulate(Color(1,1,1,1))
