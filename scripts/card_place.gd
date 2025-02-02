class_name CardPlace extends Node2D

var card: Card = null
signal joker_bought(card: Card) 
@onready var buy_button = $Buy_button
@onready var gold_cost = $gold_cost
@onready var gold_cost_label = $gold_cost/gold_cost_label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buy_button.hide()
	gold_cost.hide()
	if not buy_button.is_connected("pressed", Callable(self, "_on_buy_button_pressed")):
		buy_button.connect("pressed", Callable(self, "_on_buy_button_pressed"))
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_card(_card: Card) -> void:
	add_child(_card)
	card = _card
	gold_cost.show()
	var joker = turn_card_into_a_joker(_card)
	if joker:
		gold_cost_label.set_text(str(joker.effect.joker_price))
		
func turn_card_into_a_joker(card: Card) -> Joker:
	var path: String = "res://scenes/jokers/Joker_" + str(card.card_value) + "_" + str(card.card_suit) + ".tscn"
	var joker_scene = load(path)
	if joker_scene:
		var joker = joker_scene.instantiate()
		if joker:
			joker.card_value = card.card_value
			joker.card_suit = card.card_suit
			joker.card_path = card.card_path
			joker.connect("mouse_entered_joker", Callable(self, "_on_mouse_entered_joker"))
			joker.connect("mouse_exited_joker", Callable(self, "_on_mouse_exited_joker"))
			return joker
	return null
	
func _on_area_2d_mouse_entered() -> void:
	if card != null:
		card.position.y -= 2
		gold_cost.position.y -= 2
		card.highlight()
		buy_button.show()
		buy_button.position.y += 21
		var joker = turn_card_into_a_joker(card)
		if joker:
			get_parent().get_parent().joker_effect_label.set_text(joker.effect.joker_effect)
	
	
func _on_area_2d_mouse_exited() -> void:
	if card != null:
		card.position.y += 2
		gold_cost.position.y += 2
		card.unhighlight()
		buy_button.position.y -= 21
		buy_button.hide()
		get_parent().get_parent().joker_effect_label.set_text('Hower a card to see its joker effect')


func _on_buy_button_pressed() -> void:
	var total_gold = get_parent().get_parent().get_parent().total_gold
	var cost = int(gold_cost_label.get_text())
	if cost <= total_gold:
		get_parent().get_parent().get_parent().total_gold -= cost
		emit_signal("joker_bought", card)
		remove_child(card)
		buy_button.position.y -= 21
		buy_button.hide()
		gold_cost.hide()
		get_parent().get_parent().joker_effect_label.set_text('Hower a card to see its joker effect')
		get_parent().get_parent().gold_ammount_label.set_text(str(get_parent().get_parent().get_parent().total_gold))
	#	remove_child(buy_button)
