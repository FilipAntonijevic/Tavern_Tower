class_name Joker_1_spades extends Node2D

var joker_effect = "When you play this card, remove enemies upcomming attacks."

var joker_price: int = 1

var activation_window = 'on_this_card_played'
func activate(_activation_window: String, deck: Deck, ui: Ui, _card: Card):
	if activation_window == _activation_window:
		if _card.card_suit == "spades" and _card.card_value == 1:
			ui.get_parent().enemy.remove_upcomming_attacks()
			highlight()


func highlight():
	$"../Sprite2D".set_modulate(Color(1,0.1,0.2,1))
	await get_tree().create_timer(0.5).timeout
	$"../Sprite2D".set_modulate(Color(1,1,1,1))
