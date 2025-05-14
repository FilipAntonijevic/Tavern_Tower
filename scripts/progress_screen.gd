class_name Progress_screen extends Node2D

@onready var progress_screen = $ProgressScreen
@onready var progress_screen_next_button = $ProgressScreenNextButtonBigger

@onready var x_labels = $X_labels
@onready var o_labels = $O_labels

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
	await get_tree().create_timer(0.5).timeout
	var x_label_name = "Label" + str(i)
	x_labels.find_child(x_label_name).show()
	
	get_parent().enemy_number += 1
	i = get_parent().enemy_number
	await get_tree().create_timer(0.5).timeout
	var o_label_name = "Label" + str(i)
	o_labels.find_child(o_label_name).show()

func _on_button_pressed() -> void:
	emit_signal("go_to_shop")

func _on_button_mouse_entered() -> void:
	progress_screen.hide()
	progress_screen_next_button.show()

func _on_button_mouse_exited() -> void:
	progress_screen.show()
	progress_screen_next_button.hide()
