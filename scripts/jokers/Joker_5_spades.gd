class_name Joker_5_spades extends Node2D

var joker_effect = "Prevents cards from being shuffled by shuffle debuff."
var joker_price: int = 2

var activation_window = 'on_cards_dealt'
func activate(_activation_window: String, deck: Deck, ui: Ui, _card: Card):
	pass

func highlight():
	$"../Sprite2D".set_modulate(Color(1,0.1,0.2,1))
	await get_tree().create_timer(0.5).timeout
	$"../Sprite2D".set_modulate(Color(1,1,1,1))
