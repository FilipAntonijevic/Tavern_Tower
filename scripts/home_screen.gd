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

func _on_play_pressed() -> void:
	play_this_sound_effect("res://sound/effects/button_click.mp3")
	in_home_screen_currently = false
	main.show()
	main.reset()
	play_button.hide()
	legacy_button.hide()
	exit_button.hide()

func _on_legacy_mode_pressed() -> void:
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
