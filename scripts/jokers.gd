extends Node2D

@onready var joker_place_1 = $JokerPlace1
@onready var joker_place_2 = $JokerPlace2 
@onready var joker_place_3 = $JokerPlace3
@onready var joker_place_4 = $JokerPlace4
@onready var joker_place_5 = $JokerPlace5

var jokers_positions: Array = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	jokers_positions= [joker_place_1.position, joker_place_2.position, joker_place_3.position, joker_place_4.position, joker_place_5.position]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
