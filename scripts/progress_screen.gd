class_name Progress_screen extends Node2D

@onready var next_button = $next
@onready var home_screen_button = $home_screen
@onready var progress_screen = $ProgressScreen
@onready var progress_screen_next_button = $ProgressScreenNextButtonBigger

@onready var x_labels = $X_labels
@onready var o_labels = $O_labels

@onready var soundfx_player = $soundfx_player
@onready var coins_and_gems = $coins_and_gems

signal go_to_shop()

func _ready() -> void:
	var i = get_parent().enemy_number
	var old_o_label_name = "Label" + str(i)
	o_labels.find_child(old_o_label_name).hide()
	
	for label in x_labels.get_children():
		if i == 1:
			break
		label.show()
		i -= 1
		
	i = get_parent().enemy_number
	await get_tree().create_timer(0.8).timeout
	var x_label_name = "Label" + str(i)
	x_labels.find_child(x_label_name).show()
	play_this_sound_effect("res://sound/effects/x_sound.mp3")
	
	if get_parent().enemy_number == 20:
		for child in coins_and_gems.get_children():
			child.show()
			play_this_sound_effect("res://sound/effects/gem_sound.mp3")
			await get_tree().create_timer(0.2).timeout
		home_screen_button.show()
		return
	else:
		get_parent().enemy_number += 1
		i = get_parent().enemy_number
		await get_tree().create_timer(0.8).timeout
		var o_label_name = "Label" + str(i)
		o_labels.find_child(o_label_name).show()
		play_this_sound_effect("res://sound/effects/o_sound.mp3")

	next_button.show()
	
func check_if_you_won() -> void:
	if get_parent().enemy_number == 21:
		pass
	
func _on_button_pressed() -> void:
	play_this_sound_effect("res://sound/effects/button_click.mp3")
	emit_signal("go_to_shop")

func _on_button_mouse_entered() -> void:
	progress_screen.hide()
	progress_screen_next_button.show()

func _on_button_mouse_exited() -> void:
	progress_screen.show()
	progress_screen_next_button.hide()


func play_this_sound_effect(path: String) -> void:
	if path.is_empty():
		return
	var audio_stream = load(path)
	if audio_stream is AudioStream:
		soundfx_player.stream = audio_stream
		soundfx_player.play()
	else:
		push_warning("Invalid audio stream at path: " + path)


func _on_home_screen_pressed() -> void:
	play_this_sound_effect("res://sound/effects/button_click.mp3")
	get_parent().get_parent().in_home_screen_currently = true
	get_tree().change_scene_to_file("res://scenes/home_screen.tscn")


func _on_home_screen_mouse_entered() -> void:
	progress_screen.hide()
	progress_screen_next_button.show()

func _on_home_screen_mouse_exited() -> void:
	progress_screen.show()
	progress_screen_next_button.hide()
