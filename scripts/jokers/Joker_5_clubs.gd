class_name Joker_5_clubs extends Node2D

var joker_effect = "When played place next card on each other pile."
var joker_price: int = 3

var activation_window = 'on_this_card_played'
func activate(_activation_window: String, deck: Deck, ui: Ui, _card: Card):
	if activation_window == _activation_window:
		if _card.card_suit == "clubs" and _card.card_value == 5:
			var spades_value = ui.card_piles.current_card_value_on_spades_pile + 1
			var diamonds_value = ui.card_piles.current_card_value_on_diamonds_pile + 1
			var hearts_value = ui.card_piles.current_card_value_on_hearts_pile + 1
			
			var array_of_stacks = ui.stacks.get_children()
			for stack in array_of_stacks:
				for i in range(stack.cards_in_stack.size() - 1, -1, -1): #ovako iterira niz otpozadi, sto mora, jer ako izbaci nekog keca iz steka, ostalim kartama u steku se promene indeksi
					var card = stack.cards_in_stack[i]
					if card.card_suit == "spades" and card.card_value == spades_value:
						stack.move_card_from_stack_to_a_pile(deck, card)
					if card.card_suit == "diamonds" and card.card_value == diamonds_value:
						stack.move_card_from_stack_to_a_pile(deck, card)
					if card.card_suit == "hearts" and card.card_value == hearts_value:
						stack.move_card_from_stack_to_a_pile(deck, card)
					highlight()
				
func highlight():
	$"../Sprite2D".set_modulate(Color(1,0.1,0.2,1))
	await get_tree().create_timer(0.5).timeout
	$"../Sprite2D".set_modulate(Color(1,1,1,1))
