class_name Joker_6_diamonds extends Node2D

var joker_effect = "When you play 1,2,3,4,5, double the score."
var joker_price: int = 4

var activation_window = 'on_card_played'
func activate(_activation_window: String, deck: Deck, ui: Ui, _card: Card):
	if activation_window == _activation_window:
		if _card.card_value < 6:
			highlight()
			ui.get_parent().enemy.set_visual_aid_label('x2')
			await wait(0.3)
			ui.get_parent().enemy.set_visual_aid_label('')
			ui.get_parent().enemy.set_score_value(ui.get_parent().enemy.score * 2)
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
	await get_tree().create_timer(0.5).timeout
	$"../Sprite2D".set_modulate(Color(1,1,1,1))
