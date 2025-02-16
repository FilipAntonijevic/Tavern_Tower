class_name Joker_5_spades extends Node2D

var joker_effect = " -TODO"
var joker_price: int = 3

var activation_window = 'on_cards_dealt'
func activate(_activation_window: String, deck: Deck, ui: Ui, _card: Card):
	pass
			
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
