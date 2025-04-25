class_name Home_screen extends Node2D

@onready var main = $Main
@onready var play_button = $Play
@onready var legacy_button = $Legacy_mode

@onready var main_menu = $MainMenu
@onready var main_menu_play_button_bigger = $MainMenuPlayButtonBigger
@onready var main_menu_legacy_button_bigger = $MainMenuLegacyButtonBigger


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	main.show()
	play_button.hide()
	legacy_button.hide()

func _on_play_mouse_entered() -> void:
	main_menu.hide()
	main_menu_play_button_bigger.show()


func _on_play_mouse_exited() -> void:
	main_menu.show()
	main_menu_play_button_bigger.hide()

func _on_legacy_mode_pressed() -> void:
	pass

func _on_legacy_mode_mouse_entered() -> void:
	main_menu.hide()
	main_menu_legacy_button_bigger.show()

func _on_legacy_mode_mouse_exited() -> void:
	main_menu.show()
	main_menu_legacy_button_bigger.hide()
