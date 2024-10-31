class_name Card_piles extends Node2D

@onready var spades_pile: Node2D = $Spades_pile
@onready var diamonds_pile: Node2D = $Diamonds_pile
@onready var clubs_pile: Node2D = $Clubs_pile
@onready var hearts_pile: Node2D = $Hearts_pile

@onready var current_card_value_on_spades_pile: int = 0
@onready var current_card_value_on_diamonds_pile: int = 0
@onready var current_card_value_on_clubs_pile: int = 0
@onready var current_card_value_on_hearts_pile: int = 0

var current_selected_pile: Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_current_card_value_on_spades_pile(value: int):
	current_card_value_on_spades_pile = value

func set_current_card_value_on_clubs_pile(value: int):
	current_card_value_on_spades_pile = value

func set_current_card_value_on_diamonds_pile(value: int):
	current_card_value_on_spades_pile = value
	
func set_current_card_value_on_hearts_pile(value: int):
	current_card_value_on_spades_pile = value

func _on_spades_mouse_entered() -> void:
	print('pik uso')
	current_selected_pile = spades_pile
	highlight_card_that_can_be_played_on_this_pile(current_card_value_on_spades_pile + 1, "spades")

func _on_spades_mouse_exited() -> void:
	print('pik izaso')
	get_parent().stacks.touched_card_value = 0
	current_selected_pile = null
	
func _on_diamonds_mouse_entered() -> void:
	print('karo uso')
	highlight_card_that_can_be_played_on_this_pile(current_card_value_on_diamonds_pile + 1, "diamonds")
	current_selected_pile = diamonds_pile

func _on_diamonds_mouse_exited() -> void:
	print('karo izaso')
	get_parent().stacks.touched_card_value = 0
	current_selected_pile = null

func _on_clubs_mouse_entered() -> void:
	highlight_card_that_can_be_played_on_this_pile(current_card_value_on_clubs_pile + 1, "clubs")	
	current_selected_pile = clubs_pile

func _on_clubs_mouse_exited() -> void:
	get_parent().stacks.touched_card_value = 0
	current_selected_pile = null

func _on_hearts_mouse_entered() -> void:
	highlight_card_that_can_be_played_on_this_pile(current_card_value_on_hearts_pile + 1, "hearts")
	current_selected_pile = hearts_pile

func _on_hearts_mouse_exited() -> void:
	get_parent().stacks.touched_card_value = 0
	current_selected_pile = null

func highlight_card_that_can_be_played_on_this_pile(value: int, suit: String):
	var deck = get_parent().original_deck.card_collection
	for key in deck:
		var card = deck[key]
		if card != null && card.card_sprite != null && card.card_value == value && card.card_suit == suit:
			get_parent().stacks.touched_card_value = value
			card.card_sprite.set_modulate(Color(1,1,0.6,1))
