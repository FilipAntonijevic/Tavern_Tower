class_name Joker_13_hearts extends Node

var joker_effect = "When you play 3 hearts add 20 to the score."
var joker_price: int = 5

var activation_window: String = 'on_card_played'
var suit_counter: int = 3

func activate(_activation_window: String, deck: Deck, ui: Ui, card: Card):
	
	if activation_window == _activation_window:
		if card.card_suit == 'hearts':
			suit_counter -= 1
			if suit_counter == 0:
				suit_counter = 3
				highlight()
				ui.get_parent().enemy.set_visual_aid_label('+20')
				await wait(0.3)
				ui.get_parent().enemy.set_visual_aid_label('')
				ui.get_parent().enemy.set_score_value(ui.get_parent().enemy.score + 20)
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
