extends Node2D

@onready var ui = $Ui
@onready var original_deck: Deck = Deck.new()

@onready var game_control: GameController = $GameController

func restart_game():
	#game_control.current_state = GameController.GameState.PLAYER_TURN
	ui.reset(original_deck)

	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui.set_deck(original_deck)
	ui.initialize_deck()
	$Label.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !game_control.is_running:
		return
	
	if ui.check_if_you_won():
		$Label.visible = true

func _on_button_3_pressed() -> void:
	restart_game()
	ui.place_cards_from_deck_on_the_table(original_deck)


func _on_button_pressed() -> void:
	restart_game()
