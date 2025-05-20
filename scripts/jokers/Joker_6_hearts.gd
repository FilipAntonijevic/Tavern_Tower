class_name Joker_6_hearts extends Node2D

var joker_effect = "When you play this card, gain 1 gold."
var joker_price: int = 2

var activation_window = 'on_this_card_played'
func activate(_activation_window: String, deck: Deck, ui: Ui, _card: Card):
	if activation_window == _activation_window:
		if _card.card_suit == "hearts" and _card.card_value == 6:
			highlight()
			ui.get_parent().update_coins(ui.get_parent().enemy_gold + 1)
			
func highlight():
	$"../Sprite2D".set_modulate(Color(1,0.1,0.2,1))
	await get_tree().create_timer(0.5).timeout
	$"../Sprite2D".set_modulate(Color(1,1,1,1))
