class_name OneOfEach_joker extends Node

var activation_window: String = 'on_card_played'
var array_of_suits: Array = ['spade', 'diamond', 'club', 'heart']

func activate(_activation_window: String, deck: Deck, ui: Ui, card: Card):
	
	if activation_window == _activation_window:
		if card.card_suit == 'spades':
			array_of_suits.erase('spade')
		if card.card_suit == 'diamonds':
			array_of_suits.erase('diamond')
		if card.card_suit == 'clubs':
			array_of_suits.erase('club')
		if card.card_suit == 'hearts':
			array_of_suits.erase('heart')
		if array_of_suits.size() == 0:
			array_of_suits = ['spade', 'diamond', 'club', 'heart']
			ui.deal_dmg(10)
			highlight()

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
