class_name Home_screen extends Node2D

@onready var main = $Main
@onready var play_button = $Play
@onready var legacy_button = $Legacy_mode_button
@onready var legacy_mode = $LegacyMode
@onready var exit_button = $Exit_button
@onready var options_button = $Options

@onready var main_menu = $MainMenu
@onready var main_menu_play_button_bigger = $MainMenuPlayButtonBigger
@onready var main_menu_legacy_button_bigger = $MainMenuLegacyButtonBigger
@onready var exit_button_bigger = $MainMenuExitButtonBigger
@onready var options_screen = $OptionsScreen

@onready var music_player = $music_player
@onready var soundfx_player = $soundfx_player

func _ready() -> void:
	Engine.max_fps = 60
	if not FileAccess.file_exists("user://game_info.txt"):
		GameInfo.save_game()
	else:
		load_game()

func load_game():
	var file = FileAccess.open("user://game_info.txt", FileAccess.READ)
	if file == null:
		return

	while not file.eof_reached():
		var line = file.get_line()
		var data = line.split("=")
		if data.size() == 2:
			var key = data[0]
			var value = data[1]

			match key:
				"toggled_on":
					GameInfo.toggled_on = value == "true"
				"in_home_screen_currently":
					GameInfo.in_home_screen_currently = value == "true"
				"soundfx_value":
					GameInfo.soundfx_value = int(value)
				"soundfx_volume_db":
					GameInfo.soundfx_volume_db = float(value)
				"total_gold":
					GameInfo.total_gold = int(value)
				"enemy_gold":
					GameInfo.enemy_gold = int(value)
				"enemy_goal":
					GameInfo.enemy_goal = int(value)
				"enemy_number":
					GameInfo.enemy_number = int(value)
				"enemy_level":
					GameInfo.enemy_level = int(value)
				"joker_1":
					GameInfo.joker_1 = str(value)
				"joker_2":
					GameInfo.joker_2 = str(value)
				"joker_3":
					GameInfo.joker_3 = str(value)
				"joker_4":
					GameInfo.joker_4 = str(value)
				"joker_5":
					GameInfo.joker_5 = str(value)
	file.close()
	load_jokers()
	var debug_file = FileAccess.open("user://game_info.txt", FileAccess.READ)
	if debug_file:
		print("--- Sadržaj fajla nakon loada ---")
		while not debug_file.eof_reached():
			print(debug_file.get_line())
		debug_file.close()
		
func _on_play_pressed() -> void:
	play_this_sound_effect("res://sound/effects/button_click.mp3")
	GameInfo.in_home_screen_currently = false
	main.show()
	play_button.hide()
	legacy_button.hide()
	exit_button.hide()
	if GameInfo.current_scene_name == "Board":
		GameInfo.current_scene.set_jokers(main.jokers)
		#main.load_scene("res://scenes/Board.tscn")
	if GameInfo.current_scene_name == "Shop" or GameInfo.current_scene_name == "Progress_screen":
		GameInfo.current_scene.set_jokers(main.jokers)
		#main.load_scene("res://scenes/Shop.tscn")
		await GameInfo.new_scene.excavate_card()
		await GameInfo.new_scene.excavate_card()
		await GameInfo.new_scene.excavate_card()
		
func _on_legacy_mode_pressed() -> void:
	set_legacy_mode_soundfx_player_volume()
	play_this_sound_effect("res://sound/effects/button_click.mp3")
	GameInfo.in_home_screen_currently = false
	legacy_mode.show()
	play_button.hide()
	legacy_button.hide()
	exit_button.hide()
	
func _on_exit_button_pressed() -> void:
	play_this_sound_effect("res://sound/effects/button_click.mp3")
	get_tree().quit()

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		_on_options_pressed()
		
func _on_options_pressed() -> void:
	if GameInfo.toggled_on:
		options_screen.show()
		if GameInfo.in_home_screen_currently:
			options_screen.back_to_main_menu.hide()
		GameInfo.toggled_on = false
	else:
		options_screen.hide()
		options_screen.back_to_main_menu.show()
		GameInfo.toggled_on = true

func _on_play_mouse_entered() -> void:
	main_menu.hide()
	main_menu_play_button_bigger.show()
func _on_play_mouse_exited() -> void:
	main_menu.show()
	main_menu_play_button_bigger.hide()

func _on_legacy_mode_mouse_entered() -> void:
	main_menu.hide()
	main_menu_legacy_button_bigger.show()
func _on_legacy_mode_mouse_exited() -> void:
	main_menu.show()
	main_menu_legacy_button_bigger.hide()

func _on_exit_button_mouse_entered() -> void:
	main_menu.hide()
	exit_button_bigger.show()

func _on_exit_button_mouse_exited() -> void:
	main_menu.show()
	exit_button_bigger.hide()

func _on_options_mouse_entered() -> void:
	options_button.pivot_offset = options_button.size / 2
	options_button.rotation_degrees = 15
	
func _on_options_mouse_exited() -> void:
	options_button.rotation = deg_to_rad(0)

func play_this_sound_effect(path: String) -> void:
	if path.is_empty():
		return
	var audio_stream = load(path)
	if audio_stream is AudioStream:
		soundfx_player.stream = audio_stream
		soundfx_player.play()
	else:
		push_warning("Invalid audio stream at path: " + path)

func set_soundfx_volume_to(volume_db: float) -> void:
	if GameInfo.board != null:
		GameInfo.board.soundfx_player.volume_db = volume_db
		GameInfo.board.ui.soundfx_player.volume_db = volume_db
	elif GameInfo.shop != null:
		GameInfo.shop.soundfx_player.volume_db = volume_db
	elif GameInfo.progress_screen != null:
		GameInfo.progress_screen.soundfx_player.volume_db = volume_db
	else:
		soundfx_player.volume_db = volume_db
		
func set_soundfx_volume() -> void:
	var volume_db = lerp(-80, 0, GameInfo.soundfx_value / 100.0)
	set_soundfx_volume_to(volume_db)
	
func set_home_screen_soundfx_player_volume() -> void:
	var volume_db = lerp(-80, 0, GameInfo.soundfx_value / 100.0)
	soundfx_player.volume_db = volume_db

func set_legacy_mode_soundfx_player_volume() -> void:
	var volume_db = lerp(-80, 0, GameInfo.soundfx_value / 100.0)
	legacy_mode.soundfx_player.volume_db = volume_db
	legacy_mode.ui.soundfx_player.volume_db = volume_db

func load_jokers() -> void:
	var card_value_1: String
	var card_suit_1: String
	var parts_1 = GameInfo.joker_1.split("_")
	if parts_1.size() == 2:
		card_value_1 = parts_1[0]
		card_suit_1 = parts_1[1]
	
	for card_id in GameInfo.original_deck.card_collection.keys():
		var card = GameInfo.original_deck.card_collection[card_id]
		if card.card_suit == card_suit_1 and str(card.card_value) == card_value_1:
			main.add_joker(card)
			GameInfo.original_deck.remove_card_by_value_and_suit(card)
			
	var card_value_2: String
	var card_suit_2: String
	var parts_2 = GameInfo.joker_2.split("_")
	if parts_2.size() == 2:
		card_value_2 = parts_2[0]
		card_suit_2 = parts_2[1]
	
	for card_id in GameInfo.original_deck.card_collection.keys():
		var card = GameInfo.original_deck.card_collection[card_id]
		if card.card_suit == card_suit_2 and str(card.card_value) == card_value_2:
			main.add_joker(card)
			GameInfo.original_deck.remove_card_by_value_and_suit(card)
			
	var card_value_3: String
	var card_suit_3: String
	var parts_3 = GameInfo.joker_3.split("_")
	if parts_3.size() == 2:
		card_value_3 = parts_3[0]
		card_suit_3 = parts_3[1]
	
	for card_id in GameInfo.original_deck.card_collection.keys():
		var card = GameInfo.original_deck.card_collection[card_id]
		if card.card_suit == card_suit_3 and str(card.card_value) == card_value_3:
			main.add_joker(card)
			GameInfo.original_deck.remove_card_by_value_and_suit(card)
			
	var card_value_4: String
	var card_suit_4: String
	var parts_4 = GameInfo.joker_4.split("_")
	if parts_4.size() == 2:
		card_value_4 = parts_4[0]
		card_suit_4 = parts_4[1]
	
	for card_id in GameInfo.original_deck.card_collection.keys():
		var card = GameInfo.original_deck.card_collection[card_id]
		if card.card_suit == card_suit_4 and str(card.card_value) == card_value_4:
			main.add_joker(card)
			GameInfo.original_deck.remove_card_by_value_and_suit(card)
			
	var card_value_5: String
	var card_suit_5: String
	var parts_5 = GameInfo.joker_5.split("_")
	if parts_5.size() == 2:
		card_value_5 = parts_5[0]
		card_suit_5 = parts_5[1]
	
	for card_id in GameInfo.original_deck.card_collection.keys():
		var card = GameInfo.original_deck.card_collection[card_id]
		if card.card_suit == card_suit_5 and str(card.card_value) == card_value_5:
			main.add_joker(card)
			GameInfo.original_deck.remove_card_by_value_and_suit(card)
