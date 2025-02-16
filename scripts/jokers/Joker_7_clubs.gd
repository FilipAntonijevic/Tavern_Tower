class_name Joker_7_clubs extends Node2D

var joker_effect = "When played, make random card emerald."
var joker_price: int = 3

var activation_window = 'on_this_card_played'
func activate(_activation_window: String, deck: Deck, ui: Ui, _card: Card):
	if activation_window == _activation_window:
		if _card.card_suit == "spades" and _card.card_value == 7:
			var array_of_stacks = ui.stacks.get_children()
			var upper_bound = 0
			for stack in array_of_stacks:
				upper_bound += stack.cards_in_stack.size()
			var random_number = randi_range(0, upper_bound)
			for stack in array_of_stacks:
				for i in range(stack.cards_in_stack.size() - 1, -1, -1):
					if random_number == 0:
						highlight()
						var card = stack.cards_in_stack[i]
						card.highlight_emerald_card()
						card.ruby = false
						card.topaz = false
						card.emerald = true
						card.sapphire = false
					random_number -= 1
			
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
