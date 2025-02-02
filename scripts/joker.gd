class_name Joker extends Node2D

@export var effect: Node2D
@export var card_value: int = 0
@export var card_suit: String = "Card Suit"
@export var card_path: String = "Card Path"

@onready var area_2d: Area2D = $Area2D
@onready var card_sprite: Sprite2D = $Sprite2D

var mouse_is_inside_this_joker: bool = false
signal mouse_entered_joker(joker)
signal mouse_exited_joker()

func activate(_activation_window: String, deck: Deck, ui: Ui, card: Card):
	effect.activate(_activation_window, deck, ui, card)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not area_2d.is_connected("mouse_entered", Callable(self, "_on_area_2d_mouse_entered")):
		area_2d.connect("mouse_entered", Callable(self, "_on_area_2d_mouse_entered"))
	if not area_2d.is_connected("mouse_exited", Callable(self, "_on_area_2d_mouse_exited")):
		area_2d.connect("mouse_exited", Callable(self, "_on_area_2d_mouse_exited"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func highlight():
	card_sprite.set_modulate(Color(0.1,1,0.7,1))

func unhighlight():
	card_sprite.set_modulate(Color(1,1,1,1))


func _on_area_2d_mouse_entered() -> void:
	mouse_is_inside_this_joker = true
	emit_signal("mouse_entered_joker", self) 
	highlight()


func _on_area_2d_mouse_exited() -> void:
	mouse_is_inside_this_joker = false
	emit_signal("mouse_exited_joker")
	unhighlight()
