extends Control

@onready var anim = $ShineAnimation
@onready var shine_timer = Timer.new()

func _ready():
	add_child(shine_timer)
	shine_timer.wait_time = 2.0
	shine_timer.one_shot = false
	shine_timer.timeout.connect(start_shine)
	shine_timer.start()

func start_shine():
	anim.play("shine")
