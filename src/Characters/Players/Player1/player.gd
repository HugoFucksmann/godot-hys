extends GlobalCharacter

func _ready():
	initialize_character(100.0, 600.0, 50.0) # health, speed, damage

func play_walk_animation():
	$HappyBoo.play_walk_animation()

func play_idle_animation():
	$HappyBoo.play_idle_animation()
