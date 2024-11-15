class_name Joker extends Node2D

@export var effect: Node2D

func activate(_activation_window: String, deck: Deck, ui: Ui, card: Card):
	effect.activate(_activation_window, deck, ui, card)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
