class_name Joker extends Node2D

@export var effect: Node2D
@export var card_value: int = 0
@export var card_suit: String = "Card Suit"
@export var card_path: String = "Card Path"

@onready var area_2d: Area2D = $Area2D
@onready var card_sprite: Sprite2D = $Sprite2D

var is_dragging: bool = false

var mouse_is_inside_this_joker: bool = false
signal mouse_entered_joker(joker)
signal mouse_exited_joker()
signal joker_sold(joker)

var this_jokers_position = null

func activate(_activation_window: String, deck: Deck, ui: Ui, card: Card):
	effect.activate(_activation_window, deck, ui, card)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not area_2d.is_connected("mouse_entered", Callable(self, "_on_area_2d_mouse_entered")):
		area_2d.connect("mouse_entered", Callable(self, "_on_area_2d_mouse_entered"))
	if not area_2d.is_connected("mouse_exited", Callable(self, "_on_area_2d_mouse_exited")):
		area_2d.connect("mouse_exited", Callable(self, "_on_area_2d_mouse_exited"))
	if not is_connected("joker_sold", Callable(self, "_on_joker_sold")):
		connect("joker_sold", Callable(self, "_on_joker_sold"))
		

func _process(delta: float) -> void:
	pass

func highlight():
	card_sprite.set_modulate(Color(0.1,1,0.7,1))

func unhighlight():
	card_sprite.set_modulate(Color(1,1,1,1))


func _on_area_2d_mouse_entered() -> void:
	mouse_is_inside_this_joker = true
	emit_signal("mouse_entered_joker", self) 
	print(str(self.get_parent().get_parent().get_parent().name))
	highlight()
	position.y += 2

func _on_area_2d_mouse_exited() -> void:
	mouse_is_inside_this_joker = false
	emit_signal("mouse_exited_joker")
	unhighlight()
	position.y -= 2

func _input(event):
	
	if mouse_is_inside_this_joker and get_parent().get_parent().get_parent().name == "Shop":
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed and mouse_is_inside_this_joker:
			emit_signal("joker_sold", self) 
			
		if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed: #drag selected joker
				get_parent().get_parent().get_parent().drag_selected_joker(self)
			elif is_dragging == true: #drop this joker
				is_dragging = false
				get_parent().get_parent().get_parent().assign_new_position_to_previously_dragged_joker(self)
				_on_area_2d_mouse_entered()
				get_parent().get_parent().get_parent().current_selected_joker_for_movement = null
		#dragging this joker
		elif event is InputEventMouseMotion and is_dragging == true and get_parent().get_parent().get_parent().current_selected_joker_for_movement != null:
			get_parent().get_parent().get_parent().current_selected_joker_for_movement.global_position = get_global_mouse_position()
			get_parent().get_parent().get_parent().update_jokers_positions()
