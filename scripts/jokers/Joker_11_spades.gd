class_name Joker_11_spades extends Node

var joker_effect = "When you clear a stack deal 10 dmg."
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
				print('desiti')
		if full_stacks_counter + cleared_stacks_counter < 18:
			cleared_stacks_counter += 1
			full_stacks_counter = 18
			highlight()
			ui.add_to_score(10)
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
	var timer = Timer.new()
	timer.wait_time = 0.3
	timer.one_shot = true
	add_child(timer)
	timer.start()
	await timer.timeout
	timer.queue_free()	
	$"../Sprite2D".set_modulate(Color(1,1,1,1))
