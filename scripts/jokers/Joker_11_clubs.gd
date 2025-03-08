class_name Joker_11_clubs extends Node

var joker_effect = "When you play consecative cards of same suit deal 5 dmg"
var joker_price: int = 7

var activation_window: String = 'on_card_played'
var last_suit_played: String = 'null'

func activate(_activation_window: String, deck: Deck, ui: Ui, _card: Card):
	
	if activation_window == _activation_window:
		if last_suit_played == _card.card_suit:
				ui.add_to_score(5)
				highlight()
		else:
			last_suit_played = _card.card_suit
		

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
