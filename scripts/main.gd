class_name Main extends Node2D

@onready var jokers = $Jokers

var jokers_array: Array = []

func reset() -> void:
	var parent = get_parent()
	var new_instance = load("res://scenes/main.tscn").instantiate()
	new_instance.position = position
	parent.add_child(new_instance)
	queue_free() 
	
func _ready():
	jokers_array = []
	jokers_array.append(GameInfo.joker_1)
	jokers_array.append(GameInfo.joker_2)
	jokers_array.append(GameInfo.joker_3)
	jokers_array.append(GameInfo.joker_4)
	jokers_array.append(GameInfo.joker_5)
	var cursor_texture = load("res://sprites/cursor.png")
	Input.set_custom_mouse_cursor(cursor_texture)
	GameInfo.original_deck.initialize_deck()

func increase_enemy_strength():
	GameInfo.enemy_goal += 25
	
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
					joker.connect("mouse_entered_joker", Callable(self, "_on_mouse_entered_joker"))
					joker.connect("mouse_exited_joker", Callable(self, "_on_mouse_exited_joker"))
					joker.connect("joker_sold", Callable(self, "_on_joker_sold"))
					return
					
func load_scene(scene_path: String) -> void:
	if GameInfo.current_scene:
		GameInfo.current_scene = null
	
	GameInfo.new_scene = load(scene_path).instantiate()
	if scene_path == "res://scenes/Board.tscn":
		GameInfo.new_scene.set_deck(copy_deck())
		add_child(GameInfo.new_scene)
		GameInfo.current_scene = GameInfo.new_scene
		var i = 0
		for joker_place in jokers.get_children():
			if joker_place.joker != null:
				i+=1
				joker_place.joker.z_index = 100
		GameInfo.new_scene.set_jokers(jokers)
		GameInfo.new_scene.connect("show_progress_bar", Callable(self, "_on_show_progress_bar"))
		GameInfo.board = GameInfo.new_scene
		GameInfo.shop = null
		GameInfo.progress_screen = null
	elif scene_path == "res://scenes/Shop.tscn":
		GameInfo.new_scene.set_deck(copy_deck())
		add_child(GameInfo.new_scene)
		GameInfo.current_scene = GameInfo.new_scene
		GameInfo.new_scene.connect("show_board", Callable(self, "_on_show_board"))
		GameInfo.shop = GameInfo.new_scene
		GameInfo.board = null
		GameInfo.progress_screen = null
	elif scene_path == "res://scenes/progress_screen.tscn":
		GameInfo.new_scene.connect("go_to_shop", Callable(self, "_on_go_to_shop"))
		add_child(GameInfo.new_scene)
		GameInfo.current_scene = GameInfo.new_scene
		GameInfo.progress_screen = GameInfo.new_scene
		GameInfo.board = null
		GameInfo.shop = null
	save_jokers()
	save_gemmed_cards()
	GameInfo.save_game()

func copy_deck() -> Deck:
	save_gemmed_cards()
	var deck_copy = Deck.new()
	
	for card_id in GameInfo.original_deck.card_collection.keys():
		var card = GameInfo.original_deck.card_collection[card_id]
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
	jokers_array = []
	for joker_place in jokers.get_children():
		if joker_place.joker != null:
			joker_place.joker.free()
		
	for i in range(0,5):
		if jokers_shop.get_child(i).joker != null:
			var joker = jokers_shop.get_child(i).joker.duplicate(DUPLICATE_SCRIPTS | DUPLICATE_GROUPS | DUPLICATE_SIGNALS)
			jokers.get_child(i).set_joker(joker)
			jokers_array.append(str(joker.card_value) + '_' + joker.card_suit)
			
func _on_go_to_shop() -> void:
	GameInfo.current_scene_name = "Shop"
	await load_scene("res://scenes/Shop.tscn")
	await GameInfo.new_scene.excavate_card()
	await GameInfo.new_scene.excavate_card()
	await GameInfo.new_scene.excavate_card()
	GameInfo.new_scene.next_button.show()
	
func _on_show_board() -> void:
	GameInfo.current_scene_name = "Board"
	load_scene("res://scenes/Board.tscn")
	
func _on_show_progress_bar() -> void:
	GameInfo.current_scene_name = "Progress_screen"
	load_scene("res://scenes/progress_screen.tscn")

func set_soundfx_volume_to(volume_db: float) -> void:
	GameInfo.current_scene.soundfx_player.volume_db = volume_db
	
func save_jokers() -> void:
	if jokers_array.size() >= 1:
		GameInfo.joker_1 = jokers_array[0]
	if jokers_array.size() >= 2:
		GameInfo.joker_2 = jokers_array[1]
	if jokers_array.size() >= 3:
		GameInfo.joker_3 = jokers_array[2]
	if jokers_array.size() >= 4:
		GameInfo.joker_4 = jokers_array[3]
	if jokers_array.size() == 5:
		GameInfo.joker_5 = jokers_array[4]

func save_gemmed_cards() -> void:
	for card_id in GameInfo.original_deck.card_collection.keys():
		var card = GameInfo.original_deck.card_collection[card_id]
		if is_instance_valid(card):
			var card_name = card.card_suit + '_' + str(card.card_value)
			
			if GameInfo.get(card_name) == 'ruby':
				card.ruby = true
				card.sapphire = false
				card.emerald = false
				card.topaz = false
			elif GameInfo.get(card_name) == 'emerald':
				card.ruby = false
				card.sapphire = false
				card.emerald = true
				card.topaz = false
			elif GameInfo.get(card_name) == 'sapphire':
				card.ruby = false
				card.sapphire = true
				card.emerald = false
				card.topaz = false
			elif GameInfo.get(card_name) == 'topaz':
				card.ruby = false
				card.sapphire = false
				card.emerald = false
				card.topaz = true
			elif GameInfo.get(card_name) == "":
				card.ruby = false
				card.sapphire = false
				card.emerald = false
				card.topaz = false
