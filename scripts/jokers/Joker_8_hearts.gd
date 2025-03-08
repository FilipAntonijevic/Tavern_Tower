class_name Joker_8_hearts extends Node2D

var joker_effect = "If this is your only joker, x3 the score on card played."
var joker_price: int = 5

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
			await wait(0.3)
			ui.get_parent().enemy.set_visual_aid_label('')
			ui.get_parent().enemy.set_score_value(ui.get_parent().enemy.score * 3)
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
