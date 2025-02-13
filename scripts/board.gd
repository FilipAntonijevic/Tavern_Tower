extends Node2D

@onready var ui = $Ui
var original_deck: Deck = null
var enemy_gold: int = 0

@onready var game_control: GameController = $GameController

@onready var enemy: Enemy = $enemy
@onready var coins = $coins

@onready var jokers = $Jokers

signal show_shop

func set_deck(deck: Deck) -> void:
	original_deck = deck
	
func restart_game():
	enemy.unlock_stacks()
	game_control.current_state = GameController.GameState.PLAYER_TURN
	ui.clear_stacks()

func _ready() -> void:
	$Label.visible = false
	ui.set_deck(original_deck)
	enemy_gold = get_parent().enemy_gold
	hide_coins(10)
	show_coins()

func hide_coins(k: int) -> void:
	var i = 0
	for coin in coins.get_children():
		coin.hide()
		i += 1
		if i == k:
			return
	
func show_coins() -> void:
	var i = 0
	for coin in coins.get_children():
		coin.show()
		i += 1
		if i == enemy_gold:
			return

func _process(delta: float) -> void:
	if game_control.current_state == GameController.GameState.ENEMY_TURN:
		enemy.reduce_goal_by_score_ammount()
		enemy.ability()
		game_control.transition(GameController.GameState.PLAYER_TURN)
		
	if !game_control.is_running:
		return
	
	if check_if_you_beat_enemy():
		get_parent().total_gold += enemy_gold
		emit_signal("show_shop")
		hide() 
		
	if ui.check_if_you_won():
		$Label.visible = true
		
func check_if_you_beat_enemy() -> bool:
	if enemy.goal <= 0:
		return true
	return false 
	
func set_jokers(jokers_parent: Node) -> void:
	for i in range(0,5):
		if jokers_parent.get_child(i).joker != null:
			var joker = jokers_parent.get_child(i).joker.duplicate(DUPLICATE_SCRIPTS | DUPLICATE_GROUPS | DUPLICATE_SIGNALS)
			jokers.get_child(i).remove_child(joker)
			jokers.get_child(i).set_joker(joker)
	add_child(jokers)
		
func handle_jokers(activation_window: String, card: Card):
	for joker_place in jokers.get_children():
		if joker_place.joker != null:
			var joker = joker_place.joker
			joker.activate(activation_window,original_deck, ui, card)
			var timer1 = Timer.new()
			timer1.wait_time = 0.3
			timer1.one_shot = true
			add_child(timer1)
			timer1.start()
			await timer1.timeout
			timer1.queue_free()
	end_turn()
		
func _on_deal_cards_pressed() -> void:
	restart_game()
	ui.place_cards_from_deck_on_the_table()
	var timer = Timer.new()
	timer.wait_time = 1 #treba tacno 0.78 s da se podele sve karte pa tek onda da pocnu da rade jokeri da se ne zbune al bode ako je 0.79 iz nekog razloga
	timer.one_shot = true
	add_child(timer)
	timer.start()
	await timer.timeout
	timer.queue_free()
	
	handle_jokers('on_cards_dealt', null)

func end_turn() -> void:
	if game_control.current_state == GameController.GameState.PLAYER_TURN:
		game_control.transition(GameController.GameState.ENEMY_TURN)


func _on_go_to_shop_pressed() -> void:
	for joker_place in jokers.get_children():
		if joker_place.joker != null:
			#joker_place.remove_child(joker_place.joker)
			joker_place.joker.card_sprite.texture = null
			joker_place.joker.free()
		joker_place.free()
	emit_signal("show_shop") 
	#reset_board()
	hide()  
	
func reset_board() -> void:
	enemy.unlock_stacks()
	game_control.current_state = GameController.GameState.PLAYER_TURN
	ui.reset(original_deck)
	for child in ui.card_piles.get_children():
		if child.is_inside_tree():
			var card = child as Card
			if card:
				original_deck.add_card(card)
				ui.card_piles.remove_child(child)
