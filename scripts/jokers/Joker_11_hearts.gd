class_name Joker_11_hearts extends Node

var joker_effect = "When cards on all 4 piles have the same value, add 50 to the score."
var joker_price: int = 5

var activation_window: String = 'on_card_played'
func activate(_activation_window: String, deck: Deck, ui: Ui, _card: Card):
	
	if activation_window == _activation_window:
		if _card.card_suit == 'spades' and _card.card_value == ui.card_piles.current_card_value_on_clubs_pile and _card.card_value == ui.card_piles.current_card_value_on_diamonds_pile and _card.card_value == ui.card_piles.current_card_value_on_hearts_pile:
			highlight()
			ui.get_parent().enemy.set_visual_aid_label('+50')
			await get_tree().create_timer(0.3).timeout
			ui.get_parent().enemy.set_visual_aid_label('')
			ui.get_parent().enemy.set_score_value(ui.get_parent().enemy.score + 50)
			await get_tree().create_timer(1).timeout
		if _card.card_suit == 'clubs' and _card.card_value == ui.card_piles.current_card_value_on_spades_pile and _card.card_value == ui.card_piles.current_card_value_on_diamonds_pile and _card.card_value == ui.card_piles.current_card_value_on_hearts_pile:
			highlight()
			ui.get_parent().enemy.set_visual_aid_label('+50')
			await get_tree().create_timer(0.3).timeout
			ui.get_parent().enemy.set_visual_aid_label('')
			ui.get_parent().enemy.set_score_value(ui.get_parent().enemy.score + 50)
			await get_tree().create_timer(1).timeout
		if _card.card_suit == 'diamonds' and _card.card_value == ui.card_piles.current_card_value_on_clubs_pile and _card.card_value == ui.card_piles.current_card_value_on_spades_pile and _card.card_value == ui.card_piles.current_card_value_on_hearts_pile:
			highlight()
			ui.get_parent().enemy.set_visual_aid_label('+50')
			await get_tree().create_timer(0.3).timeout
			ui.get_parent().enemy.set_visual_aid_label('')
			ui.get_parent().enemy.set_score_value(ui.get_parent().enemy.score + 50)
			await get_tree().create_timer(1).timeout
		if _card.card_suit == 'hearts' and _card.card_value == ui.card_piles.current_card_value_on_clubs_pile and _card.card_value == ui.card_piles.current_card_value_on_diamonds_pile and _card.card_value == ui.card_piles.current_card_value_on_spades_pile:
			highlight()
			ui.get_parent().enemy.set_visual_aid_label('+50')
			await get_tree().create_timer(0.3).timeout
			ui.get_parent().enemy.set_visual_aid_label('')
			ui.get_parent().enemy.set_score_value(ui.get_parent().enemy.score + 50)
			await get_tree().create_timer(1).timeout

	
func highlight():
	$"../Sprite2D".set_modulate(Color(1,0.1,0.2,1))
	await get_tree().create_timer(0.5).timeout
	$"../Sprite2D".set_modulate(Color(1,1,1,1))
