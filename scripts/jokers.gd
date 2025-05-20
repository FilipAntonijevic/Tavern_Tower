extends Node2D

@onready var joker_place_1 = $JokerPlace1
@onready var joker_place_2 = $JokerPlace2 
@onready var joker_place_3 = $JokerPlace3
@onready var joker_place_4 = $JokerPlace4
@onready var joker_place_5 = $JokerPlace5

var jokers_positions: Array = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	jokers_positions= [joker_place_1.position, joker_place_2.position, joker_place_3.position, joker_place_4.position, joker_place_5.position]


func show_popup_window()-> void:
	if get_parent().name == "board":
		var i = 0
		for joker_place in get_children():
			if joker_place.joker != null and joker_place.mouse_is_inside_the_joker_place:
				var popup_window = get_parent().popup_window
				popup_window.show()
				popup_window.set_effect_label_text(joker_place.joker.effect.joker_effect)
				popup_window.set_new_position(i)
			i += 1
func hide_popup_window()-> void:
	if get_parent().name == "board":
		var popup_window = get_parent().popup_window
		popup_window.hide()
		popup_window.set_effect_label_text("")
