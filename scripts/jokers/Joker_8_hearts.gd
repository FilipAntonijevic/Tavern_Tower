class_name Joker_8_hearts extends Node2D

var joker_effect = "If this is your only joker, x3 the score on card played."
var joker_price: int = 4

var activation_window = 'on_card_played'
func activate(_activation_window: String, deck: Deck, ui: Ui, _card: Card):
	var i = 0
	if activation_window == _activation_window:
		for joker_place in ui.get_parent().jokers.get_children():
			if joker_place.joker != null:
				i += 1
		if i == 1:
			highlight()
			ui.get_parent().enemy.set_visual_aid_label('x3')
			await get_tree().create_timer(0.3).timeout
			ui.get_parent().enemy.set_visual_aid_label('')
			ui.get_parent().enemy.set_score_value(ui.get_parent().enemy.score * 3)
			await get_tree().create_timer(1).timeout
	
			
func highlight():
	$"../Sprite2D".set_modulate(Color(1,0.1,0.2,1))
	await get_tree().create_timer(0.5).timeout
	$"../Sprite2D".set_modulate(Color(1,1,1,1))
