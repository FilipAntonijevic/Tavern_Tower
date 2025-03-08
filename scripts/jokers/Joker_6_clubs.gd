class_name Joker_6_clubs extends Node2D

var joker_effect = "When played, +1 the score for each gem card on the table."
var joker_price: int = 2

var activation_window = 'on_this_card_played'
func activate(_activation_window: String, deck: Deck, ui: Ui, _card: Card):
	if activation_window == _activation_window:
		if _card.card_suit == "clubs" and _card.card_value == 6:
			var array_of_stacks = ui.stacks.get_children()
	
			var new_score = 0
			for stack in array_of_stacks:
				for i in range(stack.cards_in_stack.size() - 1, -1, -1):
					var card = stack.cards_in_stack[i]
					if card.emerald == true or card.topaz == true  or card.ruby == true or card.sapphire == true:
						new_score += 1
			ui.get_parent().enemy.set_visual_aid_label('+' + str(new_score))
			await Engine.get_main_loop().create_timer(0.3).timeout
			ui.get_parent().enemy.set_visual_aid_label('')
			ui.get_parent().enemy.set_score_value(ui.get_parent().enemy.score + new_score)
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
