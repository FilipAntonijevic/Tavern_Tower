class_name Joker_11_hearts extends Node

var joker_effect = "When cards on all 4 piles have the same value, deal 15 dmg"

var activation_window: String = 'on_card_played'
var array_of_possible_equal_numbers: Array = [1,2,3,4,5,6,7,8,9,10,11,12,13]
func activate(_activation_window: String, deck: Deck, ui: Ui, _card: Card):
	
	if activation_window == _activation_window:
		if ui.card_piles.current_card_value_on_spades_pile == ui.card_piles.current_card_value_on_diamonds_pile && ui.card_piles.current_card_value_on_diamonds_pile == ui.card_piles.current_card_value_on_clubs_pile && ui.card_piles.current_card_value_on_clubs_pile == ui.card_piles.current_card_value_on_hearts_pile:
			if ui.card_piles.current_card_value_on_spades_pile in array_of_possible_equal_numbers:
				array_of_possible_equal_numbers.erase(ui.card_piles.current_card_value_on_spades_pile)
				ui.add_to_score(15)
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
