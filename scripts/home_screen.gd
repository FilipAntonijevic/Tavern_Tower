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
	GameInfo.in_home_screen_currently = true
	load_sound_and_music_volume()

func set_music_volume_to() -> void:
	options_screen.music_volume_slider.value = GameInfo.music_value
	GameInfo.music_volume_db = lerp(-80, 0, GameInfo.music_value / 100.0)
	music_player.volume_db = GameInfo.music_volume_db
	
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
					
				"spades_1":
					GameInfo.spades_1 = str(value)
				"spades_2":
					GameInfo.spades_2 = str(value)
				"spades_3":
					GameInfo.spades_3 = str(value)
				"spades_4":
					GameInfo.spades_4 = str(value)
				"spades_5":
					GameInfo.spades_5 = str(value)
				"spades_6":
					GameInfo.spades_6 = str(value)
				"spades_7":
					GameInfo.spades_7 = str(value)
				"spades_8":
					GameInfo.spades_8 = str(value)
				"spades_9":
					GameInfo.spades_9 = str(value)
				"spades_10":
					GameInfo.spades_10 = str(value)
				"spades_11":
					GameInfo.spades_11 = str(value)
				"spades_12":
					GameInfo.spades_12 = str(value)
				"spades_13":
					GameInfo.spades_13 = str(value)
				
				"diamonds_1":
					GameInfo.diamonds_1 = str(value)
				"diamonds_2":
					GameInfo.diamonds_2 = str(value)
				"diamonds_3":
					GameInfo.diamonds_3 = str(value)
				"diamonds_4":
					GameInfo.diamonds_4 = str(value)
				"diamonds_5":
					GameInfo.diamonds_5 = str(value)
				"diamonds_6":
					GameInfo.diamonds_6 = str(value)
				"diamonds_7":
					GameInfo.diamonds_7 = str(value)
				"diamonds_8":
					GameInfo.diamonds_8 = str(value)
				"diamonds_9":
					GameInfo.diamonds_9 = str(value)
				"diamonds_10":
					GameInfo.diamonds_10 = str(value)
				"diamonds_11":
					GameInfo.diamonds_11 = str(value)
				"diamonds_12":
					GameInfo.diamonds_12 = str(value)
				"diamonds_13":
					GameInfo.diamonds_13 = str(value)
				
				"clubs_1":
					GameInfo.clubs_1 = str(value)
				"clubs_2":
					GameInfo.clubs_2 = str(value)
				"clubs_3":
					GameInfo.clubs_3 = str(value)
				"clubs_4":
					GameInfo.clubs_4 = str(value)
				"clubs_5":
					GameInfo.clubs_5 = str(value)
				"clubs_6":
					GameInfo.clubs_6 = str(value)
				"clubs_7":
					GameInfo.clubs_7 = str(value)
				"clubs_8":
					GameInfo.clubs_8 = str(value)
				"clubs_9":
					GameInfo.clubs_9 = str(value)
				"clubs_10":
					GameInfo.clubs_10 = str(value)
				"clubs_11":
					GameInfo.clubs_11 = str(value)
				"clubs_12":
					GameInfo.clubs_12 = str(value)
				"clubs_13":
					GameInfo.clubs_13 = str(value)
					
				"hearts_1":
					GameInfo.hearts_1 = str(value)
				"hearts_2":
					GameInfo.hearts_2 = str(value)
				"hearts_3":
					GameInfo.hearts_3 = str(value)
				"hearts_4":
					GameInfo.hearts_4 = str(value)
				"hearts_5":
					GameInfo.hearts_5 = str(value)
				"hearts_6":
					GameInfo.hearts_6 = str(value)
				"hearts_7":
					GameInfo.hearts_7 = str(value)
				"hearts_8":
					GameInfo.hearts_8 = str(value)
				"hearts_9":
					GameInfo.hearts_9 = str(value)
				"hearts_10":
					GameInfo.hearts_10 = str(value)
				"hearts_11":
					GameInfo.hearts_11 = str(value)
				"hearts_12":
					GameInfo.hearts_12 = str(value)
				"hearts_13":
					GameInfo.hearts_13 = str(value)
	file.close()
	load_jokers()
	load_sound_and_music_volume()

func load_sound_and_music_volume() -> void:
	set_soundfx_volume()
	set_music_volume_to()
	
func _on_play_pressed() -> void:
	play_this_sound_effect("res://sound/effects/button_click.mp3")
	GameInfo.in_home_screen_currently = false
	GameInfo.update_sounfdx_volume()
	main.show()
	play_button.hide()
	legacy_button.hide()
	exit_button.hide()
	main.save_gemmed_cards()

	if GameInfo.current_scene_name == "Board":
		main.load_scene("res://scenes/Board.tscn")

	if GameInfo.current_scene_name == "Shop" or GameInfo.current_scene_name == "Progress_screen":
		main.load_scene("res://scenes/Shop.tscn")
		await GameInfo.new_scene.excavate_card()
		await GameInfo.new_scene.excavate_card()
		await GameInfo.new_scene.excavate_card()
		GameInfo.new_scene.next_button.show()

func _on_legacy_mode_pressed() -> void:
	GameInfo.in_home_screen_currently = false
	GameInfo.in_legacy_mode_currently = true

	GameInfo.legacy_mode = load("res://scenes/legacy_mode.tscn").instantiate()
	get_tree().current_scene.add_child(GameInfo.legacy_mode)

	play_this_sound_effect("res://sound/effects/button_click.mp3")
	GameInfo.legacy_mode.show()

	play_button.hide()
	legacy_button.hide()
	exit_button.hide()

	GameInfo.update_sounfdx_volume()

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
			options_screen.surrender_button.hide()
			exit_button.hide()
			legacy_button.hide()
			play_button.hide()
		elif GameInfo.in_legacy_mode_currently:
			options_screen.surrender_button.hide()
		GameInfo.toggled_on = false
	else:
		options_screen.hide()
		options_screen.back_to_main_menu.show()
		options_screen.surrender_button.show()
		GameInfo.toggled_on = true
		if GameInfo.in_home_screen_currently:
			exit_button.show()
			legacy_button.show()
			play_button.show()
		
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
		
func set_soundfx_volume() -> void:
	options_screen.soundfx_slider.value = GameInfo.soundfx_value
	GameInfo.soundfx_volume_db = lerp(-80, 0, GameInfo.soundfx_value / 100.0)
	soundfx_player.volume_db = GameInfo.soundfx_volume_db
	GameInfo.update_sounfdx_volume()

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
	


func _on_music_player_finished() -> void:
	music_player.play()
