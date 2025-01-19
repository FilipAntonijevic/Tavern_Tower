class_name Ui extends Node2D

@onready var card_scene: PackedScene = preload("res://scenes/card.tscn")
@onready var card_piles: Card_piles = $CardPiles

@onready var stacks = $Stacks

var origin_stack: Stack = null
var current_selected_card_for_movement: Card = null
var current_selected_card_for_movement_position: Vector2 = Vector2.ZERO
var original_deck: Deck = null
var double_click_timer: Timer
var card_dealing_timer: Timer
var timer: Timer  # Global timer variable
var current_selected_joker = null


@onready var spades_pile: Node2D = card_piles.spades_pile
@onready var diamonds_pile: Node2D = card_piles.diamonds_pile
@onready var clubs_pile: Node2D = card_piles.clubs_pile
@onready var hearts_pile: Node2D = card_piles.hearts_pile

var is_dragging: bool = false

func check_if_you_won() -> bool:
	if card_piles.current_card_value_on_spades_pile == 13 && card_piles.current_card_value_on_diamonds_pile == 13 && card_piles.current_card_value_on_clubs_pile == 13 &&  card_piles.current_card_value_on_hearts_pile == 13:
		return true
	return false

func set_deck(new_deck: Deck):
	original_deck = new_deck 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	double_click_timer = Timer.new()
	double_click_timer.wait_time = 0.25 # Adjust wait time for double-click threshold
	double_click_timer.one_shot = true
	add_child(double_click_timer)
	
	card_dealing_timer = Timer.new()
	card_dealing_timer.wait_time = 0.25
	card_dealing_timer.one_shot = true
	add_child(card_dealing_timer)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
		if double_click_timer.is_stopped():
			double_click_timer.start()
		else:
			place_card_to_according_pile()
			
	if event.is_action_pressed("right_mouse_click"):
		place_card_to_according_pile()
		
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				drag_selected_card()
			elif is_dragging == true:
					is_dragging = false
					assign_new_position_to_previously_dragged_card()
					origin_stack.reposition_cards()
					current_selected_card_for_movement = null
	elif event is InputEventMouseMotion and is_dragging == true and current_selected_card_for_movement != null:
		current_selected_card_for_movement.global_position = get_global_mouse_position()


func drag_selected_card():
	if stacks.current_selected_stack != null && stacks.current_selected_stack.locked == false && stacks.current_selected_stack.current_selected_card_index >= 0 && current_selected_card_for_movement == null && stacks.current_selected_stack.check_if_card_is_on_top_of_the_stack(stacks.current_selected_stack.current_selected_card_index):
		origin_stack = stacks.current_selected_stack
		select_card_to_move()
		is_dragging = true
		current_selected_card_for_movement.z_index = 100  
	
func assign_new_position_to_previously_dragged_card():
	if current_selected_card_for_movement == null:
		return
		
	if check_conditions_for_piles() && check_if_card_can_be_placed_on_pile(current_selected_card_for_movement):
		place_card_to_a_pile()
	elif check_conditions_for_stacks():
		if origin_stack != stacks.current_selected_stack:
			stacks.move_card_to_this_stack(origin_stack, current_selected_card_for_movement, stacks.current_selected_stack)
			current_selected_card_for_movement_position = Vector2.ZERO
			stacks.current_selected_stack.reposition_cards()
			get_parent().end_turn()
	else:
		current_selected_card_for_movement.global_position = current_selected_card_for_movement_position
		if origin_stack != stacks.current_selected_stack:
			origin_stack.reposition_cards()

func place_card_to_a_pile():
	stacks.move_card_to_according_pile(original_deck, origin_stack, current_selected_card_for_movement)
	origin_stack.current_selected_card_index = -1
	get_parent().end_turn()

func place_card_to_according_pile():
	if is_dragging == false && stacks.current_selected_stack != null && stacks.current_selected_stack.locked == false && stacks.current_selected_stack.current_selected_card_index >= 0 && stacks.current_selected_stack.check_if_card_is_on_top_of_the_stack(stacks.current_selected_stack.current_selected_card_index) && check_if_card_can_be_placed_on_pile(stacks.current_selected_stack.cards_in_stack[stacks.current_selected_stack.current_selected_card_index]):
		calculate_and_deal_dmg(stacks.current_selected_stack.cards_in_stack[stacks.current_selected_stack.current_selected_card_index])
		stacks.current_selected_stack.remove_card_from_deck_and_table(original_deck, stacks.current_selected_stack.current_selected_card_index)
		stacks.current_selected_stack.current_selected_card_index = -1
		origin_stack = stacks.current_selected_stack
		get_parent().end_turn()
		
	for joker in get_parent().jokers.get_children():
		if joker.name != "places": 
			if joker.mouse_is_inside_this_joker == true:
				place_joker_on_according_pile(joker)
				get_parent().end_turn()

func place_joker_on_according_pile(joker: Joker) -> void:
	var card = turn_joker_into_a_card(joker)
	if is_dragging == false and check_if_card_can_be_placed_on_pile(card):
		calculate_and_deal_dmg(card)
		place_card_on_according_pile(card)
		card.set_card_sprite(card.card_path)
		remove_joker_from_jokers_array(joker)
					
func place_card_on_according_pile(card: Card):
		if card.card_suit == "spades":
			spades_pile.add_child(card)
			card_piles.current_card_value_on_spades_pile += 1
		if card.card_suit == "diamonds":
			diamonds_pile.add_child(card)
			card_piles.current_card_value_on_diamonds_pile += 1
		if card.card_suit == "clubs":
			clubs_pile.add_child(card)
			card_piles.current_card_value_on_clubs_pile += 1
		if card.card_suit == "hearts":
			hearts_pile.add_child(card)
			card_piles.current_card_value_on_hearts_pile += 1
		
		get_parent().handle_jokers('on_card_played', card)


func remove_joker_from_jokers_array(joker: Joker) -> void:
	get_parent().jokers.remove_child(joker)
		
func turn_joker_into_a_card(joker: Joker) -> Card:	
	var card: Card = card_scene.instantiate()
	card.set_card_value(joker.card_value)
	card.set_card_suit(joker.card_suit)
	card.set_card_path(joker.card_path)

	return card


func calculate_and_deal_dmg(card: Card):
	deal_dmg(card.card_value)
	
func deal_dmg(value: int):
	var enemy: Enemy = get_parent().enemy
	enemy.set_health_value(enemy.health - value)
	print('enemy took ' + str(value) + ' dmg and now has ' + str(enemy.health) + ' health')

func check_if_card_can_be_placed_on_pile(card: Card) -> bool:
		
	if card.card_suit == "spades" && (card_piles.current_card_value_on_spades_pile + 1) == card.card_value:
		return true
	if card.card_suit == "diamonds" && (card_piles.current_card_value_on_diamonds_pile + 1) == card.card_value:
		return true
	if card.card_suit == "clubs" && (card_piles.current_card_value_on_clubs_pile + 1) == card.card_value:
		return true
	if card.card_suit == "hearts" && (card_piles.current_card_value_on_hearts_pile + 1) == card.card_value:
		return true
	return false
	
func check_conditions_for_piles() -> bool:
	if card_piles.current_selected_pile == spades_pile:
		if current_selected_card_for_movement.card_suit == 'spades':
			if current_selected_card_for_movement.card_value == card_piles.current_card_value_on_spades_pile + 1:
				return true
	if card_piles.current_selected_pile == clubs_pile:
		if current_selected_card_for_movement.card_suit == 'clubs':
			if current_selected_card_for_movement.card_value == card_piles.current_card_value_on_clubs_pile + 1:
				return true
	if card_piles.current_selected_pile == diamonds_pile:
		if current_selected_card_for_movement.card_suit == 'diamonds':
			if current_selected_card_for_movement.card_value == card_piles.current_card_value_on_diamonds_pile + 1:
				return true
	if card_piles.current_selected_pile == hearts_pile:
		if current_selected_card_for_movement.card_suit == 'hearts':
			if current_selected_card_for_movement.card_value == card_piles.current_card_value_on_hearts_pile + 1:
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
	
func place_cards_from_deck_on_the_table() -> void:
	original_deck = shuffle_deck(original_deck)
	timer = Timer.new()
	timer.wait_time = 0.015
	timer.one_shot = true
	add_child(timer)
	
	for i in range(original_deck.card_collection.size()):
		var card = original_deck.get_card(i)
		stacks.add_card_to_a_stack(card)
		card.set_card_sprite(card.card_path)

		timer.start()
		await timer.timeout
	timer.queue_free()

func add_card(path: String):
	var card: Card = card_scene.instantiate()
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
	
func clear_stacks():
	stacks.clear_stacks()
	
