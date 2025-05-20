class_name Joker_11_spades extends Node

var joker_effect = "When you clear a stack add 20 to the score."
var joker_price: int = 4

var activation_window: String = 'on_card_played'
var full_stacks_counter: int = 18
var cleared_stacks_counter: int = 0

func activate(_activation_window: String, deck: Deck, ui: Ui, _card: Card):
	
	if activation_window == _activation_window or _activation_window == 'on_card_dragged':
		var array_of_stacks = ui.stacks.get_children()
		for stack in array_of_stacks:
			if stack.cards_in_stack.size() == 0:
				full_stacks_counter -= 1
		if full_stacks_counter + cleared_stacks_counter < 18:
			cleared_stacks_counter += 1
			full_stacks_counter = 18
			highlight()
			ui.get_parent().enemy.set_visual_aid_label('+20')
			await get_tree().create_timer(0.3).timeout
			ui.get_parent().enemy.set_visual_aid_label('')
			ui.get_parent().enemy.set_score_value(ui.get_parent().enemy.score + 20)
			await get_tree().create_timer(1).timeout
			
	if _activation_window == 'on_cards_dealt':
		full_stacks_counter = 18
		cleared_stacks_counter = 0
		var array_of_stacks = ui.stacks.get_children()
		for stack in array_of_stacks:
			if stack.cards_in_stack.size() == 0:
				cleared_stacks_counter += 1
		full_stacks_counter -= cleared_stacks_counter

func highlight():
	$"../Sprite2D".set_modulate(Color(1,0.1,0.2,1))
	await get_tree().create_timer(0.5).timeout
	$"../Sprite2D".set_modulate(Color(1,1,1,1))
