extends Node

var toggled_on = true
var in_home_screen_currently = true
var board = null
var progress_screen = null
var shop = null
var soundfx_value = 0

var current_scene_name = "Board"
var original_deck: Deck = Deck.new()
var current_scene: Node = null 
var new_scene = null
var soundfx_volume_db = 0
var total_gold: int = 1000
var enemy_gold: int = 5
var enemy_goal: int = 25
var enemy_number: int = 1
var enemy_level: int = 0

var joker_1: String = ""
var joker_2: String = ""
var joker_3: String = ""
var joker_4: String = ""
var joker_5: String = ""

func save_game():
	var file = FileAccess.open("user://game_info.txt", FileAccess.WRITE)
	if file == null:
		return
	file.store_line("toggled_on=" + str(toggled_on))
	file.store_line("in_home_screen_currently=" + str(in_home_screen_currently))
	file.store_line("soundfx_value=" + str(soundfx_value))
	file.store_line("soundfx_volume_db=" + str(soundfx_volume_db))
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
	file.close()
	var debug_file = FileAccess.open("user://game_info.txt", FileAccess.READ)
	if debug_file:
		print("--- Sadržaj fajla nakon sejva ---")
		while not debug_file.eof_reached():
			print(debug_file.get_line())
		debug_file.close()
