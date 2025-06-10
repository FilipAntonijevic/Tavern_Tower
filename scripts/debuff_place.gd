class_name Debuff_place extends Node2D

@onready var icon = $Sprite2D
@onready var mouse_is_inside_the_debuff_place: bool = false
var debuff: String = ""

func _on_area_2d_mouse_entered() -> void:
	mouse_is_inside_the_debuff_place = true
	if debuff != "":
		show_popup_window()


func _on_area_2d_mouse_exited() -> void:
	mouse_is_inside_the_debuff_place = true
	hide_popup_window()

func show_popup_window()-> void:
	if mouse_is_inside_the_debuff_place:
		var debuff_effect: String =  ""
		if debuff == "chain":
			debuff_effect = "Prevents you from moving 1 random card until next turn."
		if debuff == "double_chain":
			debuff_effect = "Prevents you from moving 2 random cards until next turn."
		if debuff == "triple_chain":
			debuff_effect = "Prevents you from moving 3 random cards until next turn."
		if debuff == "freeze":
			debuff_effect = "Disables all joker effects until next turn."
		if debuff == "shuffle":
			debuff_effect = "Shuffles all the cards on the table."
		if debuff == "redeal":
			debuff_effect = "Increases the redeal cost by 1 gold."
		var popup_window = get_parent().get_parent().popup_window
		popup_window.show()
		popup_window.set_effect_label_text(debuff_effect)
		var popupwindow_position = Vector2(self.global_position.x, self.global_position.y + 70)
		popup_window.set_new_position_via_vector2(popupwindow_position)

func hide_popup_window()-> void:
	var popup_window = get_parent().get_parent().popup_window
	popup_window.hide()
	popup_window.set_effect_label_text("")
