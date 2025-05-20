class_name Options_screen extends Node2D

@onready var options_button = $Options_button
@onready var  back_to_main_menu = $back_to_main_menu

@onready var soundfx_player = $soundfx_player

signal hide_options_screen()

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass


func _on_options_button_pressed() -> void:
	play_this_sound_effect("res://sound/effects/button_click.mp3")
	emit_signal("hide_options_screen")


func _on_options_button_mouse_entered() -> void:
	options_button.pivot_offset = options_button.size / 2
	options_button.rotation_degrees = 15

func _on_options_button_mouse_exited() -> void:
	options_button.rotation = deg_to_rad(0)


func _on_back_to_main_menu_button_pressed() -> void:
	play_this_sound_effect("res://sound/effects/button_click.mp3")
	get_parent().in_home_screen_currently = true
	get_tree().change_scene_to_file("res://scenes/home_screen.tscn")

func play_this_sound_effect(path: String) -> void:
	if path.is_empty():
		return
	var audio_stream = load(path)
	if audio_stream is AudioStream:
		soundfx_player.stream = audio_stream
		soundfx_player.play()
	else:
		push_warning("Invalid audio stream at path: " + path)
