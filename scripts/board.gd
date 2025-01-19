extends Node2D

@onready var ui = $Ui
var original_deck: Deck = null

@onready var game_control: GameController = $GameController

@onready var enemy: Enemy = $enemy

var jokers = null

signal show_shop

func set_deck(deck: Deck) -> void:
	original_deck = deck
	
func restart_game():
	enemy.unlock_stacks()
	game_control.current_state = GameController.GameState.PLAYER_TURN
	ui.clear_stacks()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.visible = false
	$enemy/health_bar.add_theme_color_override("scrollbar_color", Color.DARK_RED)
	ui.set_deck(original_deck)

func _process(delta: float) -> void:
	if game_control.current_state == GameController.GameState.ENEMY_TURN:
		enemy.ability()
		game_control.transition(GameController.GameState.PLAYER_TURN)
		pass
		
	if !game_control.is_running:
		return
	
	if ui.check_if_you_won():
		$Label.visible = true

func set_jokers(jokers_parent: Node) -> void:
	jokers = jokers_parent.duplicate()  
	add_child(jokers)  
		
func handle_jokers(activation_window: String, card: Card):
	for joker in jokers.get_children():
		if joker.name != "places":
			joker.activate(activation_window,original_deck, ui, card)
			var timer1 = Timer.new()
			timer1.wait_time = 0.3
			timer1.one_shot = true
			add_child(timer1)
			timer1.start()
			await timer1.timeout
			timer1.queue_free()	
		
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
