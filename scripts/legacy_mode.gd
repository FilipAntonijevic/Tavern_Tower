class_name Legacy_mode extends Node2D

@onready var ui = $Ui
var legacy_deck: Deck = Deck.new()
var redeals_left: int = 2

@onready var soundfx_player = $soundfx_player

@onready var game_control: GameController = $GameController
@onready var redeal_cards_button = $redeal_cards
@onready var redeals_left_label = $redeals_left
@onready var give_up_button = $give_up

@onready var desk = $desk
@onready var desk_redeal_cards_button_bigger = $DeskTextureRedealButtonBigger
@onready var desk_surrender_button = $DeskSurrenderButton
@onready var desk_surrender_button_bigger = $DeskSurrenderButtonBigger

@onready var game_mode = "Legacy_mode"

func _ready() -> void:
	legacy_deck.initialize_deck()
	ui.set_deck(legacy_deck)
	redeal_cards()

func _process(delta: float) -> void:
	if ui.check_if_you_won():
		get_tree().change_scene_to_file("res://scenes/home_screen.tscn")

func check_if_redeal_cards_button_should_turn_into_give_up_button() -> void:
	if redeals_left == 0:
		give_up_button.show()
		redeal_cards_button.hide()
		desk_surrender_button.show()
		desk.hide()
	
func _on_redeal_cards_pressed() -> void:
	play_this_sound_effect("res://sound/effects/shuffle_sound.mp3")
	redeal_cards_button.hide()
	redeals_left -= 1
	redeals_left_label.set_text(str(redeals_left))
	check_if_redeal_cards_button_should_turn_into_give_up_button()
	redeal_cards()

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
	redeal_cards_button.show()

func _on_give_up_pressed() -> void:
	play_this_sound_effect("res://sound/effects/button_click.mp3")
	GameInfo.in_home_screen_currently = true
	get_tree().change_scene_to_file("res://scenes/home_screen.tscn")


func _on_redeal_cards_mouse_entered() -> void:
	desk.hide()
	desk_redeal_cards_button_bigger.show()
func _on_redeal_cards_mouse_exited() -> void:
	desk.show()
	desk_redeal_cards_button_bigger.hide()
	
func _on_give_up_mouse_entered() -> void:
	desk_surrender_button.hide()
	desk_surrender_button_bigger.show()
func _on_give_up_mouse_exited() -> void:
	desk_surrender_button.show()
	desk_surrender_button_bigger.hide()

func play_this_sound_effect(path: String) -> void:
	if path.is_empty():
		return
	var audio_stream = load(path)
	if audio_stream is AudioStream:
		soundfx_player.stream = audio_stream
		soundfx_player.play()
	else:
		push_warning("Invalid audio stream at path: " + path)
