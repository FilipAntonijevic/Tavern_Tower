class_name Joker_8_diamonds extends Node2D

var joker_effect = "If all your jokers are same suit, +5 the score when you play a card."
var joker_price: int = 4

var activation_window = 'on_card_played'
func activate(_activation_window: String, deck: Deck, ui: Ui, _card: Card):
	var joker_suit: String = ""
	var all_jokers_are_same_suit: bool = true
	if activation_window == _activation_window:
		for joker_place in ui.get_parent().jokers.get_children():
			if joker_place.joker != null:
				var joker_class_name = joker_place.joker.effect.get_script().resource_path.get_file().get_basename()
				var parts = joker_class_name.split("_") 
				var new_joker_suit = parts[-1]
				print(new_joker_suit)
				if joker_suit == "":
					joker_suit = new_joker_suit
				if joker_suit != new_joker_suit:
					all_jokers_are_same_suit = false
					break
		if all_jokers_are_same_suit:
			highlight()
			ui.get_parent().enemy.set_visual_aid_label('+5')
			await wait(0.3)
			ui.get_parent().enemy.set_visual_aid_label('')
			ui.get_parent().enemy.set_score_value(ui.get_parent().enemy.score + 5)
			await wait(1)
			
func wait(seconds: float) -> void:
	var timer = Timer.new()
	timer.wait_time = seconds
	timer.one_shot = true
	add_child(timer)
	timer.start()
	while timer.time_left > 0:
		await get_tree().process_frame
	timer.queue_free()
		
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
