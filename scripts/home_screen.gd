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

var toggled_on = true
var in_home_screen_currently = true

var board = null
var progress_screen = null
var shop = null

var soundfx_value = 0

func _on_play_pressed() -> void:
	play_this_sound_effect("res://sound/effects/button_click.mp3")
	in_home_screen_currently = false
	main.show()
	main.reset()
	play_button.hide()
	legacy_button.hide()
	exit_button.hide()

func _on_legacy_mode_pressed() -> void:
	set_legacy_mode_soundfx_player_volume()
	play_this_sound_effect("res://sound/effects/button_click.mp3")
	in_home_screen_currently = false
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
	if toggled_on:
		options_screen.show()
		if in_home_screen_currently:
			options_screen.back_to_main_menu.hide()
		toggled_on = false
	else:
		options_screen.hide()
		options_screen.back_to_main_menu.show()
		toggled_on = true

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
	if board != null:
		board.soundfx_player.volume_db = volume_db
		board.ui.soundfx_player.volume_db = volume_db
	elif shop != null:
		shop.soundfx_player.volume_db = volume_db
	elif progress_screen != null:
		progress_screen.soundfx_player.volume_db = volume_db
	else:
		soundfx_player.volume_db = volume_db
		
func set_soundfx_volume() -> void:
	var volume_db = lerp(-80, 0, soundfx_value / 100.0)
	set_soundfx_volume_to(volume_db)
	
func set_home_screen_soundfx_player_volume() -> void:
	var volume_db = lerp(-80, 0, soundfx_value / 100.0)
	soundfx_player.volume_db = volume_db

func set_legacy_mode_soundfx_player_volume() -> void:
	var volume_db = lerp(-80, 0, soundfx_value / 100.0)
	legacy_mode.soundfx_player.volume_db = volume_db
	legacy_mode.ui.soundfx_player.volume_db = volume_db
