@tool
class_name Card extends Node2D

signal mouse_entered_card(card: Card)
signal mouse_exited_card(card: Card)

@export var card_value: int = 0
@export var card_suit: String = "Card Suit"
@export var card_path: String = "Card Path"
@onready var card_sprite: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func get_card(name: String, path: String) -> Card:
	var card: Card = Card.new()
	set_card_suit(name)
	set_card_sprite(path)
	return card
	
func set_card_sprite(path: String):
	card_sprite.texture = load(path)

func set_card_suit(suit: String):
	card_suit = suit
	
func set_card_value(value: int):
	card_value = value
	
func set_card_path(path: String):
	card_path = path
	
func highlight():
	card_sprite.set_modulate(Color(0.7,1,0.7,1))

func unhighlight():
	card_sprite.set_modulate(Color(1,1,1,1))
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_mouse_entered() -> void:
	if get_parent().get_parent().get_parent().is_dragging == false:
		mouse_entered_card.emit(self)

func _on_area_2d_mouse_exited() -> void:
	mouse_exited_card.emit(self )

func update_card_position(x: float, y: float):
	self.set_position(Vector2(int(x),int(y)))
