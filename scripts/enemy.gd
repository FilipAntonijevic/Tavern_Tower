@tool
class_name Enemy extends Node2D

@export var max_health: int = 100
@export var health: int = 100

func set_health_value(_health: int):
	health = _health
	update_health_bar()
	
func set_max_health_value(_max_health: int):
	max_health = _max_health
	update_health_bar()

func update_health_bar():
	if ($health_bar as ProgressBar).value != health:
		($health_bar as ProgressBar).value = health
	if ($health_bar as ProgressBar).max_value != max_health:
		($health_bar as ProgressBar).max_value = max_health

func ability():
	unlock_stacks()
	var difficulty = $HSlider.value
	var i = 0
	while i < difficulty:
		lock_random_stack()
		i += 1
		
func lock_random_stack():
	var random_number = randi() % 18 + 1
	get_parent().ui.stacks.array_of_stacks[random_number].locked = true
	get_parent().ui.stacks.array_of_stacks[random_number].lock_sprite.visible = true
	
func unlock_stacks():
	var i = 1
	while i <= 18:
		if get_parent().ui.stacks.array_of_stacks[i].locked == true:
			get_parent().ui.stacks.array_of_stacks[i].locked = false
			get_parent().ui.stacks.array_of_stacks[i].lock_sprite.visible = false
		i += 1
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
