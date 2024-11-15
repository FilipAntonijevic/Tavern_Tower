extends Node2D

@onready var ui = $Ui
@onready var original_deck: Deck = Deck.new()

@onready var game_control: GameController = $GameController

@onready var enemy: Enemy = $enemy

@onready var jokers = $Jokers.get_children()

func restart_game():
	enemy.unlock_stacks()
	game_control.current_state = GameController.GameState.PLAYER_TURN
	ui.reset(original_deck)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui.set_deck(original_deck)
	ui.initialize_deck()
	$Label.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_control.current_state == GameController.GameState.ENEMY_TURN:
		enemy.ability()
		game_control.transition(GameController.GameState.PLAYER_TURN)
		pass
		
	if !game_control.is_running:
		return
	
	if ui.check_if_you_won():
		$Label.visible = true
		
func handle_jokers(activation_window: String, card: Card):
	for joker in jokers:
		joker.activate(activation_window,original_deck, ui, card)
		var timer1 = Timer.new()
		timer1.wait_time = 0.3
		timer1.one_shot = true
		add_child(timer1)
		timer1.start()
		await timer1.timeout
		timer1.queue_free()	
		
func _on_button_3_pressed() -> void:
	restart_game()
	ui.place_cards_from_deck_on_the_table(original_deck)
	
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
