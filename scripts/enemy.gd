@tool
class_name Enemy extends Node2D

@export var max_health: int = 100
@export var score: int = 0
@export var goal: int = 100
@onready var score_label = $score_label
@onready var goal_label = $goal_label
@onready var visual_aid_label = $visual_aid_label

func set_score_value(_score: int):
	score = _score
	score_label.set_text(str(score))
	
func set_goal_value(new_goal: int):
	goal = new_goal
	goal_label.set_text(str(goal))
	
		
func set_visual_aid_label(aid: String):
	visual_aid_label.set_text(str(aid))

func reduce_goal_by_score_ammount():
	await get_tree().create_timer(0.5).timeout
	while score != 0:
		score -= 1
		goal -= 1
		set_goal_value(goal)
		set_score_value(score)
		await get_tree().create_timer(0.1).timeout

func ability():
	unlock_cards()
	var difficulty = $HSlider.value
	var i = 0
	while i < difficulty:
		lock_random_card()
		i += 1

func remove_upcomming_attacks() -> void:
	pass
	

func lock_random_card():
	var number_of_cards = get_parent().original_deck.card_collection.size()
	var random_number = randi() % number_of_cards + 1
	for stack in get_parent().ui.stacks.get_children():
		for card in stack.cards_in_stack:
			random_number -= 1
			if random_number == 0:
				if card.locked :
					lock_random_card()
				else:
					if card.topaz == false:
						card.locked = true
						card.chains.show()
					else:
						pass #animacija lomljenja lanaca
				
	
func lock_random_stack():
	var random_number = randi() % 18 + 1
	get_parent().ui.stacks.array_of_stacks[random_number].locked = true
	get_parent().ui.stacks.array_of_stacks[random_number].lock_sprite.visible = true

func unlock_cards():
	for stack in get_parent().ui.stacks.get_children():
		for card in stack.cards_in_stack:
			card.chains.hide()
			card.locked = false
		
func unlock_stacks():
	var i = 1
	while i <= 18:
		if get_parent().ui.stacks.array_of_stacks[i].locked == true:
			get_parent().ui.stacks.array_of_stacks[i].locked = false
			get_parent().ui.stacks.array_of_stacks[i].lock_sprite.visible = false
		i += 1
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
