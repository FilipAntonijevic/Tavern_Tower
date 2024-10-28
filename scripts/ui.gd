extends Node2D

@onready var card_scene: PackedScene = preload("res://scenes/card.tscn")
@onready var card_piles: Card_piles = $CardPiles

@onready var stacks = $Stacks

var origin_stack: Stack = null
var current_selected_card_for_movement: Card = null
var current_selected_card_for_movement_index: int = -1
var current_selected_card_for_movement_position: Vector2 = Vector2.ZERO
var original_deck: Deck = null

@onready var spades_pile: Node2D = card_piles.spades_pile
@onready var diamonds_pile: Node2D = card_piles.diamonds_pile
@onready var clubs_pile: Node2D = card_piles.clubs_pile
@onready var hearts_pile: Node2D = card_piles.hearts_pile

@onready var spades_pile_value: int = card_piles.current_card_value_on_spades_pile
@onready var diamonds_pile_value: int = card_piles.current_card_value_on_diamonds_pile
@onready var clubs_pile_value: int = card_piles.current_card_value_on_clubs_pile
@onready var hearts_pile_value: int = card_piles.current_card_value_on_hearts_pile

var is_dragging: bool = false

func check_if_you_won() -> bool:
	if spades_pile_value == 13 && diamonds_pile_value == 13 && clubs_pile_value == 13 && hearts_pile_value == 13:
		return true
	return false

func set_deck(new_deck: Deck):
	original_deck = new_deck 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):

	if event.is_action_pressed("right_mouse_click") && is_dragging == false && stacks.current_selected_stack != null && stacks.current_selected_stack.current_selected_card_index >= 0 && stacks.current_selected_stack.check_if_card_is_on_top_of_the_stack(stacks.current_selected_stack.current_selected_card_index):
		origin_stack = stacks.current_selected_stack
		place_card_to_a_pile_via_right_click()
		
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if stacks.current_selected_stack != null && stacks.current_selected_stack.current_selected_card_index >= 0 && current_selected_card_for_movement == null && stacks.current_selected_stack.check_if_card_is_on_top_of_the_stack(stacks.current_selected_stack.current_selected_card_index):
					origin_stack = stacks.current_selected_stack
					select_card_to_move()
					is_dragging = true
					for stack in stacks.get_children():
						if stack:
							stack.is_dragging = true
					current_selected_card_for_movement.z_index = 100  # Bring to front while dragging
			elif is_dragging == true:
					is_dragging = false
					for stack in stacks.get_children():
						if stack:
							stack.is_dragging = false
					if current_selected_card_for_movement != null:
						assign_new_position_to_previously_dragged_card()
						current_selected_card_for_movement.z_index = 0
					current_selected_card_for_movement = null
	elif event is InputEventMouseMotion and is_dragging == true and current_selected_card_for_movement != null:
		current_selected_card_for_movement.global_position = get_global_mouse_position()

func assign_new_position_to_previously_dragged_card():
	if check_conditions_for_piles():
		place_card_to_a_pile()
	elif check_conditions_for_stacks():
		stacks.move_card_to_this_stack(origin_stack, current_selected_card_for_movement, stacks.current_selected_stack)
		current_selected_card_for_movement_position = Vector2.ZERO
		stacks.current_selected_stack.reposition_cards()
	else:
		current_selected_card_for_movement.global_position = current_selected_card_for_movement_position
		origin_stack.reposition_cards()

func place_card_to_a_pile():	
	stacks.move_card_to_according_pile(original_deck, origin_stack, current_selected_card_for_movement)
	origin_stack.current_selected_card_index = -1
	
func place_card_to_a_pile_via_right_click():
		stacks.current_selected_stack.remove_card_from_deck_and_table(original_deck, current_selected_card_for_movement_index)
		stacks.current_selected_stack.current_selected_card_index = -1

func check_conditions_for_piles() -> bool:
	if card_piles.current_selected_pile == spades_pile:
		if current_selected_card_for_movement.card_suit == 'spades':
			if current_selected_card_for_movement.card_value == spades_pile_value + 1:
				return true
	if card_piles.current_selected_pile == clubs_pile:
		if current_selected_card_for_movement.card_suit == 'clubs':
			if current_selected_card_for_movement.card_value == clubs_pile_value + 1:
				return true
	if card_piles.current_selected_pile == diamonds_pile:
		if current_selected_card_for_movement.card_suit == 'diamonds':
			if current_selected_card_for_movement.card_value == diamonds_pile_value + 1:
				return true
	if card_piles.current_selected_pile == hearts_pile:
		if current_selected_card_for_movement.card_suit == 'hearts':
			if current_selected_card_for_movement.card_value == hearts_pile_value + 1:
				return true
	return false
		
func check_conditions_for_stacks() -> bool:
	if stacks.current_selected_stack == null:
		print('stack == null\n')
		return false

	if current_selected_card_for_movement == null:
		return false
	if stacks.current_selected_stack.cards_in_stack.size() >= 3:
		return false
	if !stacks.check_if_card_can_be_moved_via_value(current_selected_card_for_movement, stacks.current_selected_stack):
		return false
	return true
	
func select_card_to_move():
	current_selected_card_for_movement = stacks.current_selected_stack.cards_in_stack[stacks.current_selected_stack.current_selected_card_index]
	current_selected_card_for_movement_position = current_selected_card_for_movement.global_position
	stacks.current_selected_stack.current_selected_card_index = -1
	
func place_cards_from_deck_on_the_table(deck: Deck):
	
	deck = shuffle_deck(deck)
	var i: int = 0
	while i != deck.card_collection.size():
		var card = deck.get_card(i)
		stacks.add_card(card)
		card.set_card_sprite(card.card_path)	
		i += 1

func add_card_to_deck(deck: Deck, suit: String, value: int, path: String):
	var card = card_scene.instantiate()
	card.set_card_value(value)
	card.set_card_suit(suit)
	card.set_card_path(path)
	deck.add_card(card)

func add_card(path: String):
	var card = card_scene.instantiate()
	stacks.add_card(card)	
	card.set_card_sprite(path)
	
func shuffle_deck(deck: Deck) -> Deck:
	var keys = deck.get_keys()
	keys.shuffle()
	var shuffled_deck: Dictionary 
	
	var i: int = 0
	for key in keys:
		shuffled_deck[i] = deck.card_collection[key]
		i += 1
		
	deck.card_collection = shuffled_deck
	return deck
	
func reset(deck: Deck):
	stacks.clear_stacks()
	
func initialize_deck():
	original_deck.card_collection.clear()
	add_card_to_deck(original_deck, "spades", 1, "res://sprites/card_sprites/1_spades.png")
	add_card_to_deck(original_deck, "spades", 2, "res://sprites/card_sprites/2_spades.png")
	add_card_to_deck(original_deck, "spades", 3, "res://sprites/card_sprites/3_spades.png")
	add_card_to_deck(original_deck, "spades", 4, "res://sprites/card_sprites/4_spades.png")
	add_card_to_deck(original_deck, "spades", 5, "res://sprites/card_sprites/5_spades.png")
	add_card_to_deck(original_deck, "spades", 6, "res://sprites/card_sprites/6_spades.png")
	add_card_to_deck(original_deck, "spades", 7, "res://sprites/card_sprites/7_spades.png")
	add_card_to_deck(original_deck, "spades", 8, "res://sprites/card_sprites/8_spades.png")
	add_card_to_deck(original_deck, "spades", 9, "res://sprites/card_sprites/9_spades.png")
	add_card_to_deck(original_deck, "spades", 10, "res://sprites/card_sprites/10_spades.png")
	add_card_to_deck(original_deck, "spades", 11, "res://sprites/card_sprites/j_spades.png")
	add_card_to_deck(original_deck, "spades", 12, "res://sprites/card_sprites/q_spades.png")
	add_card_to_deck(original_deck, "spades", 13, "res://sprites/card_sprites/k_spades.png")
	
	add_card_to_deck(original_deck, "diamonds", 1,  "res://sprites/card_sprites/1_diamonds.png")
	add_card_to_deck(original_deck, "diamonds", 2, "res://sprites/card_sprites/2_diamonds.png")
	add_card_to_deck(original_deck, "diamonds", 3, "res://sprites/card_sprites/3_diamonds.png")
	add_card_to_deck(original_deck, "diamonds", 4, "res://sprites/card_sprites/4_diamonds.png")
	add_card_to_deck(original_deck, "diamonds", 5, "res://sprites/card_sprites/5_diamonds.png")
	add_card_to_deck(original_deck, "diamonds", 6, "res://sprites/card_sprites/6_diamonds.png")
	add_card_to_deck(original_deck, "diamonds", 7, "res://sprites/card_sprites/7_diamonds.png")
	add_card_to_deck(original_deck, "diamonds", 8, "res://sprites/card_sprites/8_diamonds.png")
	add_card_to_deck(original_deck, "diamonds", 9, "res://sprites/card_sprites/9_diamonds.png")
	add_card_to_deck(original_deck, "diamonds", 10, "res://sprites/card_sprites/10_diamonds.png")
	add_card_to_deck(original_deck, "diamonds", 11, "res://sprites/card_sprites/j_diamonds.png")
	add_card_to_deck(original_deck, "diamonds", 12, "res://sprites/card_sprites/q_diamonds.png")
	add_card_to_deck(original_deck, "diamonds", 13, "res://sprites/card_sprites/k_diamonds.png")
	
	add_card_to_deck(original_deck, "clubs", 1, "res://sprites/card_sprites/1_clubs.png")
	add_card_to_deck(original_deck, "clubs", 2, "res://sprites/card_sprites/2_clubs.png")
	add_card_to_deck(original_deck, "clubs", 3, "res://sprites/card_sprites/3_clubs.png")
	add_card_to_deck(original_deck, "clubs", 4, "res://sprites/card_sprites/4_clubs.png")
	add_card_to_deck(original_deck, "clubs", 5, "res://sprites/card_sprites/5_clubs.png")
	add_card_to_deck(original_deck, "clubs", 6, "res://sprites/card_sprites/6_clubs.png")
	add_card_to_deck(original_deck, "clubs", 7, "res://sprites/card_sprites/7_clubs.png")
	add_card_to_deck(original_deck, "clubs", 8, "res://sprites/card_sprites/8_clubs.png")
	add_card_to_deck(original_deck, "clubs", 9, "res://sprites/card_sprites/9_clubs.png")
	add_card_to_deck(original_deck, "clubs", 10, "res://sprites/card_sprites/10_clubs.png")
	add_card_to_deck(original_deck, "clubs", 11, "res://sprites/card_sprites/j_clubs.png")
	add_card_to_deck(original_deck, "clubs", 12, "res://sprites/card_sprites/q_clubs.png")
	add_card_to_deck(original_deck, "clubs", 13, "res://sprites/card_sprites/k_clubs.png")

	add_card_to_deck(original_deck, "hearts", 1, "res://sprites/card_sprites/1_hearts.png")
	add_card_to_deck(original_deck, "hearts", 2, "res://sprites/card_sprites/2_hearts.png")
	add_card_to_deck(original_deck, "hearts", 3, "res://sprites/card_sprites/3_hearts.png")
	add_card_to_deck(original_deck, "hearts", 4, "res://sprites/card_sprites/4_hearts.png")
	add_card_to_deck(original_deck, "hearts", 5, "res://sprites/card_sprites/5_hearts.png")
	add_card_to_deck(original_deck, "hearts", 6, "res://sprites/card_sprites/6_hearts.png")
	add_card_to_deck(original_deck, "hearts", 7, "res://sprites/card_sprites/7_hearts.png")
	add_card_to_deck(original_deck, "hearts", 8, "res://sprites/card_sprites/8_hearts.png" )
	add_card_to_deck(original_deck, "hearts", 9, "res://sprites/card_sprites/9_hearts.png")
	add_card_to_deck(original_deck, "hearts", 10, "res://sprites/card_sprites/10_hearts.png")
	add_card_to_deck(original_deck, "hearts", 11, "res://sprites/card_sprites/j_hearts.png")
	add_card_to_deck(original_deck, "hearts", 12, "res://sprites/card_sprites/q_hearts.png")
	add_card_to_deck(original_deck, "hearts", 13, "res://sprites/card_sprites/k_hearts.png")
