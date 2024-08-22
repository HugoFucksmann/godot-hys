extends GlobalCharacter

@onready var happy_boo = $HappyBoo

func _ready() -> void:
	
	initialize_character(100.0, 600.0, 50.0) # health, speed, damage

func play_walk_animation() -> void:
	happy_boo.play_walk_animation()

func play_idle_animation() -> void:
	happy_boo.play_idle_animation()

