extends Node

var toggled_on = true
var in_legacy_mode_currently = false
var in_home_screen_currently = true
var board = null
var progress_screen = null
var shop = null
var legacy_mode = null

var current_scene_name = "Board"
var original_deck: Deck = Deck.new()
var current_scene: Node = null 
var new_scene = null
var soundfx_value = 100
var soundfx_volume_db = 0
var music_value = 100
var music_volume_db = 0
var total_gold: int = 0
var enemy_gold: int = 5
var enemy_goal: int = 25
var enemy_number: int = 1
var enemy_level: int = 0

var joker_1: String = ""
var joker_2: String = ""
var joker_3: String = ""
var joker_4: String = ""
var joker_5: String = ""

var spades_1: String = ""
var spades_2: String = ""
var spades_3: String = ""
var spades_4: String = ""
var spades_5: String = ""
var spades_6: String = ""
var spades_7: String = ""
var spades_8: String = ""
var spades_9: String = ""
var spades_10: String = ""
var spades_11: String = ""
var spades_12: String = ""
var spades_13: String = ""

var diamonds_1: String = ""
var diamonds_2: String = ""
var diamonds_3: String = ""
var diamonds_4: String = ""
var diamonds_5: String = ""
var diamonds_6: String = ""
var diamonds_7: String = ""
var diamonds_8: String = ""
var diamonds_9: String = ""
var diamonds_10: String = ""
var diamonds_11: String = ""
var diamonds_12: String = ""
var diamonds_13: String = ""

var clubs_1: String = ""
var clubs_2: String = ""
var clubs_3: String = ""
var clubs_4: String = ""
var clubs_5: String = ""
var clubs_6: String = ""
var clubs_7: String = ""
var clubs_8: String = ""
var clubs_9: String = ""
var clubs_10: String = ""
var clubs_11: String = ""
var clubs_12: String = ""
var clubs_13: String = ""

var hearts_1: String = ""
var hearts_2: String = ""
var hearts_3: String = ""
var hearts_4: String = ""
var hearts_5: String = ""
var hearts_6: String = ""
var hearts_7: String = ""
var hearts_8: String = ""
var hearts_9: String = ""
var hearts_10: String = ""
var hearts_11: String = ""
var hearts_12: String = ""
var hearts_13: String = ""

func save_game():
	var file = FileAccess.open("user://game_info.txt", FileAccess.WRITE)
	if file == null:
		return
	file.store_line("toggled_on=" + str(toggled_on))
	file.store_line("in_home_screen_currently=" + str(in_home_screen_currently))
	file.store_line("soundfx_value=" + str(soundfx_value))
	file.store_line("soundfx_volume_db=" + str(soundfx_volume_db))
	file.store_line("music_value=" + str(music_value))
	file.store_line("music_volume_db=" + str(music_volume_db))
	file.store_line("total_gold=" + str(total_gold))
	file.store_line("enemy_gold=" + str(enemy_gold))
	file.store_line("enemy_goal=" + str(enemy_goal))
	file.store_line("enemy_number=" + str(enemy_number))
	file.store_line("enemy_level=" + str(enemy_level))
	file.store_line("joker_1=" + str(joker_1))
	file.store_line("joker_2=" + str(joker_2))
	file.store_line("joker_3=" + str(joker_3))
	file.store_line("joker_4=" + str(joker_4))
	file.store_line("joker_5=" + str(joker_5))
	
	file.store_line("spades_1=" + str(spades_1))
	file.store_line("spades_2=" + str(spades_2))
	file.store_line("spades_3=" + str(spades_3))
	file.store_line("spades_4=" + str(spades_4))
	file.store_line("spades_5=" + str(spades_5))
	file.store_line("spades_6=" + str(spades_6))
	file.store_line("spades_7=" + str(spades_7))
	file.store_line("spades_8=" + str(spades_8))
	file.store_line("spades_9=" + str(spades_9))
	file.store_line("spades_10=" + str(spades_10))
	file.store_line("spades_11=" + str(spades_11))
	file.store_line("spades_12=" + str(spades_12))
	file.store_line("spades_13=" + str(spades_13))
	
	file.store_line("diamonds_1=" + str(diamonds_1))
	file.store_line("diamonds_2=" + str(diamonds_2))
	file.store_line("diamonds_3=" + str(diamonds_3))
	file.store_line("diamonds_4=" + str(diamonds_4))
	file.store_line("diamonds_5=" + str(diamonds_5))
	file.store_line("diamonds_6=" + str(diamonds_6))
	file.store_line("diamonds_7=" + str(diamonds_7))
	file.store_line("diamonds_8=" + str(diamonds_8))
	file.store_line("diamonds_9=" + str(diamonds_9))
	file.store_line("diamonds_10=" + str(diamonds_10))
	file.store_line("diamonds_11=" + str(diamonds_11))
	file.store_line("diamonds_12=" + str(diamonds_12))
	file.store_line("diamonds_13=" + str(diamonds_13))
	
	file.store_line("clubs_1=" + str(clubs_1))
	file.store_line("clubs_2=" + str(clubs_2))
	file.store_line("clubs_3=" + str(clubs_3))
	file.store_line("clubs_4=" + str(clubs_4))
	file.store_line("clubs_5=" + str(clubs_5))
	file.store_line("clubs_6=" + str(clubs_6))
	file.store_line("clubs_7=" + str(clubs_7))
	file.store_line("clubs_8=" + str(clubs_8))
	file.store_line("clubs_9=" + str(clubs_9))
	file.store_line("clubs_10=" + str(clubs_10))
	file.store_line("clubs_11=" + str(clubs_11))
	file.store_line("clubs_12=" + str(clubs_12))
	file.store_line("clubs_13=" + str(clubs_13))
	
	file.store_line("hearts_1=" + str(hearts_1))
	file.store_line("hearts_2=" + str(hearts_2))
	file.store_line("hearts_3=" + str(hearts_3))
	file.store_line("hearts_4=" + str(hearts_4))
	file.store_line("hearts_5=" + str(hearts_5))
	file.store_line("hearts_6=" + str(hearts_6))
	file.store_line("hearts_7=" + str(hearts_7))
	file.store_line("hearts_8=" + str(hearts_8))
	file.store_line("hearts_9=" + str(hearts_9))
	file.store_line("hearts_10=" + str(hearts_10))
	file.store_line("hearts_11=" + str(hearts_11))
	file.store_line("hearts_12=" + str(hearts_12))
	file.store_line("hearts_13=" + str(hearts_13))

	file.close()

func reset() -> void:
	toggled_on = true
	in_home_screen_currently = true
	board = null
	progress_screen = null
	shop = null

	current_scene_name = "Board"
	original_deck = Deck.new()
	current_scene = null 
	new_scene = null
	total_gold = 0
	enemy_gold = 5
	enemy_goal = 25
	enemy_number = 1
	enemy_level = 0
	
	joker_1 = ""
	joker_2 = ""
	joker_3 = ""
	joker_4 = ""
	joker_5 = ""

	spades_1 = ""
	spades_2 = ""
	spades_3 = ""
	spades_4 = ""
	spades_5 = ""
	spades_6 = ""
	spades_7 = ""
	spades_8 = ""
	spades_9 = ""
	spades_10 = ""
	spades_11 = ""
	spades_12 = ""
	spades_13 = ""
	
	diamonds_1 = ""
	diamonds_2 = ""
	diamonds_3 = ""
	diamonds_4 = ""
	diamonds_5 = ""
	diamonds_6  = ""
	diamonds_7  = ""
	diamonds_8  = ""
	diamonds_9  = ""
	diamonds_10  = ""
	diamonds_11 = ""
	diamonds_12 = ""
	diamonds_13 = ""

	clubs_1 = ""
	clubs_2 = ""
	clubs_4 = ""
	clubs_5 = ""
	clubs_6 = ""
	clubs_7 = ""
	clubs_8 = ""
	clubs_9 = ""
	clubs_10 = ""
	clubs_11 = ""
	clubs_12 = ""
	clubs_13 = ""

	hearts_1 = ""
	hearts_2 = ""
	hearts_3 = ""
	hearts_4 = ""
	hearts_5 = ""
	hearts_6 = ""
	hearts_7 = ""
	hearts_8 = ""
	hearts_9 = ""
	hearts_10 = ""
	hearts_11 = ""
	hearts_12 = ""
	hearts_13 = ""


func update_sounfdx_volume() -> void:
	if GameInfo.board != null:
		GameInfo.board.soundfx_player.volume_db = GameInfo.soundfx_volume_db
		GameInfo.board.ui.soundfx_player.volume_db = GameInfo.soundfx_volume_db
	elif GameInfo.shop != null:
		GameInfo.shop.soundfx_player.volume_db = GameInfo.soundfx_volume_db
	elif GameInfo.progress_screen != null:
		GameInfo.progress_screen.soundfx_player.volume_db = GameInfo.soundfx_volume_db
	if GameInfo.in_legacy_mode_currently:
		if GameInfo.legacy_mode != null:
			if GameInfo.legacy_mode.soundfx_player != null:
				GameInfo.legacy_mode.soundfx_player.volume_db = GameInfo.soundfx_volume_db
				GameInfo.legacy_mode.ui.soundfx_player.volume_db = GameInfo.soundfx_volume_db
			else:
				print("idk why but soundfx_player for legacy mode is null")
