class_name Home_screen extends Node2D

@onready var main = $Main
@onready var play_button = $Play
@onready var legacy_button = $Legacy_mode

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
	pass # Replace with function body.


func _on_play_mouse_exited() -> void:
	pass # Replace with function body.


func _on_legacy_mode_pressed() -> void:
	pass # Replace with function body.


func _on_legacy_mode_mouse_entered() -> void:
	pass # Replace with function body.


func _on_legacy_mode_mouse_exited() -> void:
	pass # Replace with function body.
