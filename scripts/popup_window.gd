class_name Popup_window extends Node2D

@onready var effect_label = $effect_label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_effect_label_text(effect: String)-> void:
	effect_label.set_text(effect)

func set_new_position(i: int) -> void:
	if i == 0:
		self.position = Vector2(88, 233)
	if i == 1:
		self.position = Vector2(130, 233)
	if i == 2:
		self.position = Vector2(170, 233)
	if i == 3:
		self.position = Vector2(210, 233)
	if i == 4:
		self.position = Vector2(250, 233)

func set_new_position_via_vector2(popupwindow_position)-> void:
	self.position = popupwindow_position
