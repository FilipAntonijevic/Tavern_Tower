class_name Stacks extends Node2D

@onready var stack1 = $Stack1
@onready var stack2 = $Stack2
@onready var stack3 = $Stack3
@onready var stack4 = $Stack4
@onready var stack5 = $Stack5
@onready var stack6 = $Stack6
@onready var stack7 = $Stack7
@onready var stack8 = $Stack8
@onready var stack9 = $Stack9
@onready var stack10 = $Stack10
@onready var stack11 = $Stack11
@onready var stack12 = $Stack12
@onready var stack13 = $Stack13
@onready var stack14 = $Stack14
@onready var stack15 = $Stack15
@onready var stack16 = $Stack16
@onready var stack17 = $Stack17
@onready var stack18 = $Stack18

@onready var card_scene: PackedScene = preload("res://scenes/card.tscn")

var touched_card_value = 0

var cards_on_the_table: Array = []
var array_of_stacks: Array = [Stack]

var current_selected_stack: Stack = null

func move_card_to_according_pile(original_deck: Deck, origin_stack: Stack, current_selected_card_for_movement: Card):
	origin_stack.move_card_from_stack_to_a_pile(original_deck, current_selected_card_for_movement)

func connect_stack_signals(stack: Stack):
	if not stack.mouse_entered_stack.is_connected(handle_stack_touched):
		stack.mouse_entered_stack.connect(handle_stack_touched)
	if not stack.mouse_exited_stack.is_connected(handle_stack_untouched):
		stack.mouse_exited_stack.connect(handle_stack_untouched)


func handle_stack_touched(stack: Stack):
	current_selected_stack = stack

func handle_stack_untouched():
	current_selected_stack = null
	
func initialize_stacks():	
	array_of_stacks.push_back(stack1)
	array_of_stacks.push_back(stack2)
	array_of_stacks.push_back(stack3)
	array_of_stacks.push_back(stack4)
	array_of_stacks.push_back(stack5)
	array_of_stacks.push_back(stack6)
	array_of_stacks.push_back(stack7)
	array_of_stacks.push_back(stack8)
	array_of_stacks.push_back(stack9)
	array_of_stacks.push_back(stack10)
	array_of_stacks.push_back(stack11)
	array_of_stacks.push_back(stack12)
	array_of_stacks.push_back(stack13)
	array_of_stacks.push_back(stack14)
	array_of_stacks.push_back(stack15)
	array_of_stacks.push_back(stack16)
	array_of_stacks.push_back(stack17)
	array_of_stacks.push_back(stack18)

	stack1 = connect_stack_signals(stack1)
	stack2 = connect_stack_signals(stack2)
	stack3 = connect_stack_signals(stack3)
	stack4 = connect_stack_signals(stack4)
	stack5 = connect_stack_signals(stack5)
	stack6 = connect_stack_signals(stack6)
	stack7 = connect_stack_signals(stack7)
	stack8 = connect_stack_signals(stack8)
	stack9 = connect_stack_signals(stack9)
	stack10 = connect_stack_signals(stack10)
	stack11 = connect_stack_signals(stack11)
	stack12 = connect_stack_signals(stack12)
	stack13 = connect_stack_signals(stack13)
	stack14 = connect_stack_signals(stack14)
	stack15 = connect_stack_signals(stack15)
	stack16 = connect_stack_signals(stack16)
	stack17 = connect_stack_signals(stack17)
	stack18 = connect_stack_signals(stack18)
	
func add_card_to_a_stack(card: Node2D) -> bool:
		
	if cards_on_the_table.size() < 52:
		var stack_index: int = int(cards_on_the_table.size()/3) + 1 #tradicionalno deljenje
		var stack_index2: int = int(cards_on_the_table.size()%18) + 1 #lakse deljenje
		cards_on_the_table.push_back(card)
		array_of_stacks[stack_index2].add_card(card)
		return true
	return false

func remove_card_from_table(index: int):
	if index > 0:
		var stack_index: int = int((index - 1)/3) + 1
		var remove_index: int = int((index-1)%3)
		if stack_index >=1 && stack_index <= 18:
			array_of_stacks[stack_index].remove_card_from_table(remove_index)

func move_card_to_this_stack(origin_stack: Stack, card: Card, destination_stack: Stack):
	if destination_stack.cards_in_stack.size() < 3:
		origin_stack.remove_card(card)
		destination_stack.add_card(card)
		
func check_if_card_can_be_moved_via_value(card: Card, destination_stack: Stack) -> bool:
	
	var destination_card: Card = null
	if destination_stack.cards_in_stack.size() == 3:
		destination_card = destination_stack.cards_in_stack[2]
	elif destination_stack.cards_in_stack.size() == 2:
		destination_card = destination_stack.cards_in_stack[1]
	elif destination_stack.cards_in_stack.size() == 1:
		destination_card = destination_stack.cards_in_stack[0]
		
	if destination_card != null && card.card_value == destination_card.card_value:
		return true
	return false

		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialize_stacks()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func clear_stacks():
	var stack_index: int = 1
	while stack_index <= 18:
		array_of_stacks[stack_index].remove_card_from_table(0)
		array_of_stacks[stack_index].remove_card_from_table(0)
		array_of_stacks[stack_index].remove_card_from_table(0)
		array_of_stacks[stack_index].touched_cards = []
		stack_index += 1
	cards_on_the_table = []
	
