class_name Joker_3_spades extends Node2D

var joker_effect = "Sort all spades cards in each stack"
var joker_price: int = 3

var activation_window = 'on_cards_dealt'
func activate(_activation_window: String, deck: Deck, ui: Ui, _card: Card):
	if activation_window == _activation_window:
		var array_of_stacks = ui.stacks.get_children()		
		for stack in array_of_stacks:
			for i in range(stack.cards_in_stack.size() - 1, -1, -1):
				for j1 in range(stack.cards_in_stack.size()): 
					for j2 in range(stack.cards_in_stack.size() - 1):
						if stack.cards_in_stack[j2].card_suit == "spades" and stack.cards_in_stack[j2 + 1].card_suit == "spades":
							if stack.cards_in_stack[j2].card_value < stack.cards_in_stack[j2 + 1].card_value:
								var temp = stack.cards_in_stack[j2]
								stack.cards_in_stack[j2] = stack.cards_in_stack[j2 + 1]
								stack.cards_in_stack[j2 + 1] = temp
						if stack.cards_in_stack.size() == 3 and stack.cards_in_stack[0].card_suit == "spades" and stack.cards_in_stack[2].card_suit == "spades":
							if stack.cards_in_stack[0].card_value < stack.cards_in_stack[2].card_value:
								var temp = stack.cards_in_stack[0]
								stack.cards_in_stack[0] = stack.cards_in_stack[2]
								stack.cards_in_stack[2] = temp

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
