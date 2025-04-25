class_name Joker_9_hearts extends Node

var joker_effect = "When you play a gem card, remove its gem and stun opponent next turn."
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
			ui.get_parent().enemy.remove_upcomming_attacks()
			highlight()

func wait(seconds: float) -> void:
	var timer = Timer.new()
	timer.wait_time = seconds
	timer.one_shot = true
	add_child(timer)
	timer.start()
	
	while timer.time_left > 0:
		await get_tree().process_frame
	
	timer.queue_free()

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
