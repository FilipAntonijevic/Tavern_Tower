class_name Card_piles extends Node2D

@onready var spades_pile: Node2D = $Spades_pile
@onready var diamonds_pile: Node2D = $Diamonds_pile
@onready var clubs_pile: Node2D = $Clubs_pile
@onready var hearts_pile: Node2D = $Hearts_pile

@onready var current_card_value_on_spades_pile: int = 0
@onready var current_card_value_on_diamonds_pile: int = 0
@onready var current_card_value_on_clubs_pile: int = 0
@onready var current_card_value_on_hearts_pile: int = 0

var current_selected_pile: Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_spades_mouse_entered() -> void:
	current_selected_pile = spades_pile
	
func _on_spades_mouse_exited() -> void:
	current_selected_pile = null
	
func _on_diamonds_mouse_entered() -> void:
	current_selected_pile = diamonds_pile

func _on_diamonds_mouse_exited() -> void:
	current_selected_pile = null

func _on_clubs_mouse_entered() -> void:
	current_selected_pile = clubs_pile

func _on_clubs_mouse_exited() -> void:
	current_selected_pile = null

func _on_hearts_mouse_entered() -> void:
	current_selected_pile = hearts_pile

func _on_hearts_mouse_exited() -> void:
	current_selected_pile = null
