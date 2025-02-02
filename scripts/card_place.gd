class_name CardPlace extends Node2D

var card: Card = null
signal joker_bought(card: Card) 
@onready var buy_button = $Buy_button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buy_button.hide()
	if not buy_button.is_connected("pressed", Callable(self, "_on_buy_button_pressed")):
		buy_button.connect("pressed", Callable(self, "_on_buy_button_pressed"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_card(_card: Card) -> void:
	add_child(_card)
	card = _card

func _on_area_2d_mouse_entered() -> void:
	if card != null:
		card.position.y -= 2
		card.highlight()
		buy_button.show()
		buy_button.position.y += 21
	
	
func _on_area_2d_mouse_exited() -> void:
	if card != null:
		card.position.y += 2
		card.unhighlight()
		buy_button.position.y -= 21
		buy_button.hide()


func _on_buy_button_pressed() -> void:
	emit_signal("joker_bought", card)
	remove_child(card)
	buy_button.position.y -= 21
	buy_button.hide()
#	remove_child(buy_button)
