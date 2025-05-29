class_name Joker_place extends Node2D

var this_area_is_entered = false
var joker: Joker = null
var mouse_is_inside_the_joker_place: bool = false
signal joker_sold(card: Card) 
var shop = null


func _ready() -> void:
	shop = get_parent().get_parent()

func _process(delta: float) -> void:
	pass

func set_joker(_joker: Joker) -> void:
	add_child(_joker)
	joker = _joker

func turn_joker_into_a_card(joker: Joker) -> Card:
	return null

func _on_area_2d_mouse_entered() -> void:
	if this_area_is_entered == false:
		this_area_is_entered = true
		mouse_is_inside_the_joker_place = true
		if joker != null:
			get_parent().show_popup_window()
		
func _on_area_2d_mouse_exited() -> void:
	if this_area_is_entered == true:
		this_area_is_entered = false
		mouse_is_inside_the_joker_place = false
		get_parent().hide_popup_window()

func _on_sell_joker_button_pressed() -> void:
	var sell_value = 2
	shop.get_parent().total_gold += sell_value
	#emit_signal("joker_sold", card)
	remove_child(joker)
