class_name Joker_1_clubs extends Node2D

var joker_effect = "This cards value is equal to the sum of all played cards."

var joker_price: int = 4

var activation_window = 'on_this_card_played'
func activate(_activation_window: String, deck: Deck, ui: Ui, _card: Card):
	if activation_window == _activation_window:
		var spades_value = ui.card_piles.current_card_value_on_spades_pile
		var diamonds_value = ui.card_piles.current_card_value_on_diamonds_pile
		var hearts_value = ui.card_piles.current_card_value_on_hearts_pile
		
		var total_sum = 0
		while spades_value != 0:
			total_sum += spades_value
			spades_value -= 1
		while diamonds_value != 0:
			total_sum += diamonds_value
			diamonds_value -= 1
		while hearts_value != 0:
			total_sum += hearts_value
			hearts_value -= 1
		ui.add_to_score(total_sum)
		highlight()


func highlight():
	$"../Sprite2D".set_modulate(Color(1,0.1,0.2,1))
	await get_tree().create_timer(0.5).timeout
	$"../Sprite2D".set_modulate(Color(1,1,1,1))
