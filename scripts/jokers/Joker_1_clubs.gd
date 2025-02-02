class_name Joker_1_clubs extends Node2D

var joker_effect = "This cards value is equal to the number of all played cards"

var joker_price: int = 3

var activation_window = 'on_this_card_played'
func activate(_activation_window: String, deck: Deck, ui: Ui, _card: Card):
	if activation_window == _activation_window:
		var value = ui.card_piles.current_card_value_on_spades_pile + ui.card_piles.current_card_value_on_hearts_pile + ui.card_piles.current_card_value_on_diamonds_pile
		ui.add_to_score(value)



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
