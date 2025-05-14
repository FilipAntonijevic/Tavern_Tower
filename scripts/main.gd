class_name Main extends Node2D

var original_deck: Deck = Deck.new()

var current_scene: Node = null 

var total_gold: int = 1000
var enemy_gold: int = 5
var enemy_goal: int = 25
var enemy_number: int = 1

var new_scene = null

@onready var jokers = $Jokers

func reset() -> void:
	var parent = get_parent()
	var new_instance = load("res://scenes/main.tscn").instantiate()
	new_instance.position = position
	parent.add_child(new_instance)
	queue_free() 
	
func _ready():
	Engine.max_fps = 60
	var cursor_texture = load("res://sprites/cursor.png")
	Input.set_custom_mouse_cursor(cursor_texture)
	original_deck.initialize_deck()
	load_scene("res://scenes/Board.tscn")

func increase_enemy_strength():
	enemy_goal += 25
	
func add_joker(card: Card) -> void:
	var path: String = "res://scenes/jokers/Joker_" + str(card.card_value) + "_" + str(card.card_suit) + ".tscn"
	var joker_scene = load(path)
	if joker_scene:
		var joker = joker_scene.instantiate()
		if joker:
			for joker_place in jokers.get_children():
				if joker_place.joker == null:
					joker_place.set_joker(joker)
					joker.this_jokers_position = joker.position
					joker.card_value = card.card_value
					joker.card_suit = card.card_suit
					joker.card_path = card.card_path
					return
					
func load_scene(scene_path: String) -> void:
	if current_scene:
		current_scene.queue_free() 
		current_scene = null
	
	new_scene = load(scene_path).instantiate()

	if scene_path == "res://scenes/Board.tscn":
		new_scene.set_deck(copy_deck())
		add_child(new_scene)
		current_scene = new_scene
		var i = 0
		for joker_place in jokers.get_children():
			if joker_place.joker != null:
				i+=1
				joker_place.joker.z_index = 100
		new_scene.set_jokers(jokers)
		new_scene.connect("show_progress_bar", Callable(self, "_on_show_progress_bar"))
	elif scene_path == "res://scenes/Shop.tscn":
		new_scene.set_deck(copy_deck())
		add_child(new_scene)
		current_scene = new_scene
		new_scene.connect("show_board", Callable(self, "_on_show_board"))
	elif scene_path == "res://scenes/progress_screen.tscn":
		new_scene.connect("go_to_shop", Callable(self, "_on_go_to_shop"))
		add_child(new_scene)
		current_scene = new_scene
		
func copy_deck() -> Deck:
	var deck_copy = Deck.new()

	for card_id in original_deck.card_collection.keys():
		var card = original_deck.card_collection[card_id]
		if is_instance_valid(card):
			var new_card = card.duplicate() 
			if card.topaz:
				new_card.topaz = true
			if card.emerald:
				new_card.emerald = true
			if card.ruby:
				new_card.ruby = true
			if card.sapphire:
				new_card.sapphire = true
			deck_copy.add_card(new_card)
	
	return deck_copy

func set_jokers(jokers_shop: Node) -> void:
	for joker_place in jokers.get_children():
		if joker_place.joker != null:
			#joker_place.remove_child(joker_place.joker)
			joker_place.joker.free()
		
	for i in range(0,5):
		if jokers_shop.get_child(i).joker != null:
			var joker = jokers_shop.get_child(i).joker.duplicate(DUPLICATE_SCRIPTS | DUPLICATE_GROUPS | DUPLICATE_SIGNALS)
			jokers.get_child(i).set_joker(joker)

func _on_go_to_shop() -> void:
	load_scene("res://scenes/Shop.tscn")
	await new_scene.excavate_card()
	await new_scene.excavate_card()
	await new_scene.excavate_card()
	
func _on_show_board() -> void:
	load_scene("res://scenes/Board.tscn")
	
func _on_show_progress_bar() -> void:
	load_scene("res://scenes/progress_screen.tscn")


	
