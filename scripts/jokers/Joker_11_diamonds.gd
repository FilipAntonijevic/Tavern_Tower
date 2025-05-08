class_name Joker_11_diamonds extends Node

var joker_effect = "When you play spade, club, diamond and a heart card, add 15 to the score."
var joker_price: int = 7

var activation_window: String = 'on_card_played'
var array_of_suits: Array = ['spade', 'diamond', 'club', 'heart']

func activate(_activation_window: String, deck: Deck, ui: Ui, _card: Card):
	
	if activation_window == _activation_window:
		if _card.card_suit == 'spades':
			array_of_suits.erase('spade')
		if _card.card_suit == 'diamonds':
			array_of_suits.erase('diamond')
		if _card.card_suit == 'clubs':
			array_of_suits.erase('club')
		if _card.card_suit == 'hearts':
			array_of_suits.erase('heart')
		if array_of_suits.size() == 0:
			array_of_suits = ['spade', 'diamond', 'club', 'heart']
			ui.get_parent().enemy.set_visual_aid_label('+15')
			highlight()
			await wait(0.3)
			ui.add_to_score(15)
			ui.get_parent().enemy.set_visual_aid_label('')


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
