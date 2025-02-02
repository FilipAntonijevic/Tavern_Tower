class_name Main extends Node2D

var original_deck: Deck = Deck.new()

var current_scene: Node = null 

var total_gold: int = 10
var enemy_gold: int = 5

@onready var jokers = $Jokers

func _ready():
	Engine.max_fps = 60
	original_deck.initialize_deck()
	load_scene("res://scenes/Shop.tscn") 

func add_joker(card: Card) -> void:
	var path: String = "res://scenes/jokers/Joker_" + str(card.card_value) + "_" + str(card.card_suit) + ".tscn"
	var joker_scene = load(path)
	if joker_scene:
		var joker = joker_scene.instantiate()
		if joker:
			jokers.add_child(joker)
			var joker_position_path: String = "joker_place_" + str(jokers.get_child_count() - 1)
			joker.position = jokers.get_node("places").get_node(joker_position_path).position	
			joker.card_value = card.card_value
			joker.card_suit = card.card_suit
			joker.card_path = card.card_path

func load_scene(scene_path: String) -> void:
	if current_scene:
		current_scene.queue_free() 
		current_scene = null
	
	var new_scene = load(scene_path).instantiate()
	
	var deck_copy = copy_deck() 
	new_scene.set_deck(deck_copy)

	add_child(new_scene)
	current_scene = new_scene

	if scene_path == "res://scenes/Board.tscn":
		new_scene.set_jokers(jokers)
		new_scene.connect("show_shop", Callable(self, "_on_show_shop"))
		jokers.hide()
	elif scene_path == "res://scenes/Shop.tscn":
		new_scene.connect("show_board", Callable(self, "_on_show_board"))
		jokers.show()
	
func copy_deck() -> Deck:
	var deck_copy = Deck.new()

	for card_id in original_deck.card_collection.keys():
		var card = original_deck.card_collection[card_id]
		if is_instance_valid(card):
			var new_card = card.duplicate() 
			deck_copy.add_card(new_card)
	
	return deck_copy


func _process(delta: float) -> void:
	pass
	
func _on_show_board() -> void:
	load_scene("res://scenes/Board.tscn")
	
func _on_show_shop() -> void:
	load_scene("res://scenes/Shop.tscn")
