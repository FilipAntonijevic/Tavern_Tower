class_name Joker_9_spades extends Node

var joker_effect = "When you play a gem card, remove its gem and x4 the score."
var joker_price: int = 3

var activation_window: String = 'on_card_played'
var last_suit_played: String = 'null'

func activate(_activation_window: String, deck: Deck, ui: Ui, _card: Card):
	if activation_window == _activation_window:
		if _card.sapphire or _card.topaz or _card.emerald or _card.ruby:
			_card.sapphire = false
			_card.topaz = false
			_card.emerald = false
			_card.ruby = false
			_card.highlight()
			highlight()
			ui.get_parent().enemy.set_visual_aid_label('x4')
			await get_tree().create_timer(0.3).timeout
			ui.get_parent().enemy.set_visual_aid_label('')
			ui.get_parent().enemy.set_score_value(ui.get_parent().enemy.score * 4)
			await get_tree().create_timer(1).timeout

func highlight():
	$"../Sprite2D".set_modulate(Color(1,0.1,0.2,1))
	await get_tree().create_timer(0.5).timeout
	$"../Sprite2D".set_modulate(Color(1,1,1,1))
