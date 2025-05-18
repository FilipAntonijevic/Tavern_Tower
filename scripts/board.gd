extends Node2D

@onready var ui = $Ui
var original_deck: Deck = null
var enemy_gold: int = 0
var redeal_cost: int = 0
var jokers_are_frozen: bool = false
var jokers_are_frozen_turn_counter = 0

@onready var soundfx_player = $soundfx_player
@onready var game_control: GameController = $GameController

@onready var enemy: Enemy = $enemy
@onready var coins = $coins

@onready var jokers = $Jokers
@onready var progress_label = $enemy/progress_label
@onready var goal_label = $enemy/goal_label
@onready var redeal_cards_button = $redeal_cards
@onready var redeal_cost_label = $redeal_cards/redeal_cost_label
@onready var give_up_button = $give_up

@onready var desk = $desk
@onready var desk_redeal_cards_button_bigger = $DeskTextureRedealButtonBigger
@onready var desk_surrender_button = $DeskSurrenderButton
@onready var desk_surrender_button_bigger = $DeskSurrenderButtonBigger
@onready var popup_window = $popup_window

var game_mode = "Classic_mode"

signal show_progress_bar()

func _ready() -> void:
	enemy.goal = get_parent().enemy_goal
	goal_label.set_text("/ " + str(enemy.goal))
	enemy.level_up()
	ui.set_deck(original_deck)
	update_coins(get_parent().enemy_gold)
	await redeal_cards()

func set_deck(deck: Deck) -> void:
	original_deck = deck

func _process(delta: float) -> void:
	if game_control.current_state == GameController.GameState.ENEMY_TURN:
		enemy.reduce_goal_by_score_ammount()
		enemy.unlock_cards()
		enemy.resolve_attacks()
		enemy.prepare_new_attacks()
		enemy.unfreeze_cards()
		game_control.transition(GameController.GameState.PLAYER_TURN)
				
	if !game_control.is_running:
		return
	
	if check_if_you_beat_enemy():
		get_parent().total_gold += enemy_gold
		get_parent().increase_enemy_strength()
		emit_signal("show_progress_bar")
		hide()
		
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
		if enemy_gold == 0:
			return
		coin.show()
		i += 1
		if i == enemy_gold:
			return

func update_coins(new_gold: int)-> void:
	enemy_gold = new_gold
	hide_coins(10)
	show_coins()

func check_if_redeal_cards_button_should_turn_into_give_up_button() -> void:
	if enemy_gold < redeal_cost:
		desk_surrender_button.show()
		desk.hide()
		desk_redeal_cards_button_bigger.hide()
		redeal_cards_button.hide()
		give_up_button.show()
	else:
		redeal_cards_button.show()
		give_up_button.hide()
		redeal_cost_label.set_text("- " + str(redeal_cost) + "g")
		
func check_if_you_beat_enemy() -> bool:
	if enemy.progress >= enemy.goal:
		return true
	return false 
	
func set_jokers(jokers_parent: Node) -> void:
	for i in range(0,5):
		if jokers_parent.get_child(i).joker != null:
			var joker = jokers_parent.get_child(i).joker.duplicate(DUPLICATE_SCRIPTS | DUPLICATE_GROUPS | DUPLICATE_SIGNALS)
			jokers.get_child(i).set_joker(joker)
	
		
func _on_redeal_cards_pressed() -> void:
	play_this_sound_effect("res://sound/effects/button_click.mp3")
	play_this_sound_effect("res://sound/effects/shuffle_sound.mp3")
	redeal_cards_button.hide()
	await update_coins(enemy_gold - redeal_cost)
	await redeal_cards()
	redeal_cost += 1
	await handle_jokers('on_cards_dealt', null)
	check_if_redeal_cards_button_should_turn_into_give_up_button()
	
func redeal_cards() -> void:
	game_control.current_state = GameController.GameState.PLAYER_TURN
	ui.clear_stacks()
	ui.place_cards_from_deck_on_the_table()
	var timer = Timer.new()
	timer.wait_time = 1 #treba tacno 0.78 s da se podele sve karte pa tek onda da pocnu da rade jokeri da se ne zbune al bode ako je 0.79 iz nekog razloga
	timer.one_shot = true
	add_child(timer)
	timer.start()
	await timer.timeout
	timer.queue_free()
	await handle_jokers('on_cards_dealt', null)
	check_if_redeal_cards_button_should_turn_into_give_up_button()

func end_turn() -> void:
	if jokers_are_frozen_turn_counter < 0 :
		jokers_are_frozen = 0
	if jokers_are_frozen_turn_counter == 0:
		jokers_are_frozen = false
	jokers_are_frozen_turn_counter -= 1
	if game_control.current_state == GameController.GameState.PLAYER_TURN:
		game_control.transition(GameController.GameState.ENEMY_TURN)

func _on_go_to_shop_pressed() -> void:
	get_parent().total_gold += enemy_gold
	get_parent().increase_enemy_strength()
	emit_signal("show_progress_bar")
	hide()

func handle_jokers(activation_window: String, card: Card):
	if !jokers_are_frozen:
		for joker_place in jokers.get_children():
			if joker_place.joker != null:
				var joker = joker_place.joker
				await joker.activate(activation_window, original_deck, ui, card)

func freeze_jokers() ->void:
	jokers_are_frozen = true
	jokers_are_frozen_turn_counter += 1
	for joker in jokers.get_children():
		joker.set_modulate(Color(0.65, 0.8, 0.95, 1))

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


func _on_give_up_pressed() -> void:
	play_this_sound_effect("res://sound/effects/button_click.mp3")
	get_parent().get_parent().in_home_screen_currently = true
	get_tree().change_scene_to_file("res://scenes/home_screen.tscn")


func _on_give_up_mouse_entered() -> void:
	desk_surrender_button.hide()
	desk_surrender_button_bigger.show()
	
func _on_give_up_mouse_exited() -> void:
	desk_surrender_button.show()
	desk_surrender_button_bigger.hide()

func _on_redeal_cards_mouse_entered() -> void:
	desk.hide()
	desk_redeal_cards_button_bigger.show()
	
func _on_redeal_cards_mouse_exited() -> void:
	desk.show()
	desk_redeal_cards_button_bigger.hide()

func play_this_sound_effect(path: String) -> void:
	if path.is_empty():
		return
	var audio_stream = load(path)
	if audio_stream is AudioStream:
		soundfx_player.stream = audio_stream
		soundfx_player.play()
	else:
		push_warning("Invalid audio stream at path: " + path)
