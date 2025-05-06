@tool
class_name Card extends Node2D

signal mouse_entered_card(card: Card)
signal mouse_exited_card(card: Card)

@export var card_value: int = 0
@export var card_suit: String = "Card Suit"
@export var card_path: String = "Card Path"
@onready var card_sprite: Sprite2D = $Sprite2D
@onready var chains: Sprite2D = $chains

var this_area_is_entered = false
var emerald: bool = false #when played, this card plays again (with 0 base value)
var topaz: bool = false #cannot be frozen
var ruby: bool = false #this cards base value is +10
var sapphire: bool = false #this card can be moved to any card with the same suit
var locked: bool = false

func highlight_emerald_card() -> void:
	card_sprite.set_modulate(Color(0.8, 1.0, 0.8, 1)) 

func highlight_topaz_card() -> void:
	card_sprite.set_modulate(Color(1.0, 0.9, 0.7, 1))  

func highlight_ruby_card() -> void:
	card_sprite.set_modulate(Color(1.0, 0.7, 0.7, 1)) 

func highlight_sapphire_card() -> void:
	card_sprite.set_modulate(Color(0.7, 0.8, 1.0, 1)) 

	
func _ready() -> void:
	pass 
	
func set_card_sprite(path: String):
	card_sprite.texture = load(path)

func set_card_suit(suit: String):
	card_suit = suit
	
func set_card_value(value: int):
	card_value = value
	
func set_card_path(path: String):
	card_path = path
	
func highlight():
	card_sprite.set_modulate(Color(2,5,2,1))

func unhighlight():
	card_sprite.set_modulate(Color(0.88,0.88,0.88,1))
	if emerald:
		highlight_emerald_card()
	if topaz:
		highlight_topaz_card()
	if ruby:
		highlight_ruby_card()
	if sapphire:
		highlight_sapphire_card()
		
func _process(delta: float) -> void:
	pass

func _on_area_2d_mouse_entered() -> void:
	if this_area_is_entered == false:
		this_area_is_entered = true
		if is_instance_valid(get_parent()) and get_parent() is CardPlace:
			mouse_entered_card.emit(self)
		else:
			if get_parent().get_parent().get_parent().is_dragging == false:
				mouse_entered_card.emit(self)

func _on_area_2d_mouse_exited() -> void:
	if this_area_is_entered == true:
		this_area_is_entered = false
		mouse_exited_card.emit(self )


func update_card_position(x: float, y: float):
	self.set_position(Vector2(int(x),int(y)))
