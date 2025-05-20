class_name Joker_2_clubs extends Node2D

var joker_effect = "Push clubs, in each stack, to the top of the stack."
var joker_price: int = 4

var activation_window = 'on_cards_dealt'
func activate(_activation_window: String, deck: Deck, ui: Ui, _card: Card):
	if activation_window == _activation_window:
		var array_of_stacks = ui.stacks.get_children()
		for stack in array_of_stacks:
			for i in range(stack.cards_in_stack.size() - 1, -1, -1):
					if stack.cards_in_stack[i].card_suit == "clubs":
						var card = stack.cards_in_stack[i]
						for j in range(i, stack.cards_in_stack.size() - 1):
							stack.cards_in_stack[j] = stack.cards_in_stack[j + 1]
						stack.cards_in_stack[stack.cards_in_stack.size() - 1] = card
			stack.reposition_cards()
			
func highlight():
	$"../Sprite2D".set_modulate(Color(1,0.1,0.2,1))
	await get_tree().create_timer(0.5).timeout
	$"../Sprite2D".set_modulate(Color(1,1,1,1))
