class_name Joker_6_spades extends Node2D

var joker_effect = "When played, if every other pile is <6 add 20 to the score."
var joker_price: int = 3

var activation_window = 'on_this_card_played'
func activate(_activation_window: String, deck: Deck, ui: Ui, _card: Card):
	if activation_window == _activation_window:
		if _card.card_suit == "spades" and _card.card_value == 6:
			if ui.card_piles.current_card_value_on_diamonds_pile < 6 and ui.card_piles.current_card_value_on_clubs_pile < 6 and ui.card_piles.current_card_value_on_hearts_pile < 6:
				highlight()
				ui.get_parent().enemy.set_visual_aid_label('+20')
				await Engine.get_main_loop().create_timer(0.3).timeout
				ui.get_parent().enemy.set_visual_aid_label('')
				ui.get_parent().enemy.set_score_value(ui.get_parent().enemy.score + 20)
				await Engine.get_main_loop().create_timer(1).timeout


				
func highlight():
	$"../Sprite2D".set_modulate(Color(1,0.1,0.2,1))
	var timer = Timer.new()
	timer.wait_time = 0.3
	timer.one_shot = true
	add_child(timer)
	timer.start()
	await timer.timeout
	timer.queue_free()	
	$"../Sprite2D".set_modulate(Color(1,1,1,1))
