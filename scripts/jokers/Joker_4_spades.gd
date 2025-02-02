class_name Joker_4_spades extends Node2D

var joker_effect = "Push spades, in each stack, to the top of the stack"
var joker_price: int = 3

var activation_window = 'on_cards_dealt'
func activate(_activation_window: String, deck: Deck, ui: Ui, _card: Card):
	if activation_window == _activation_window:
		var array_of_stacks = ui.stacks.get_children()
		for stack in array_of_stacks:
			for i in range(stack.cards_in_stack.size() - 1, -1, -1):
					if stack.cards_in_stack[i].card_suit == "spades":
						var card = stack.cards_in_stack[i]
						for j in range(i, stack.cards_in_stack.size() - 1):
							stack.cards_in_stack[j] = stack.cards_in_stack[j + 1]
						stack.cards_in_stack[stack.cards_in_stack.size() - 1] = card
			stack.reposition_cards()
			
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
