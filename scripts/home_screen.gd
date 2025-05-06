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
	exit_button.hide()

func _on_legacy_mode_pressed() -> void:
	legacy_mode.show()
	play_button.hide()
	legacy_button.hide()
	exit_button.hide()
	
func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_options_pressed() -> void:
	pass # Replace with function body.



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
