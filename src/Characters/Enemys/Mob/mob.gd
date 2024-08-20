extends GlobalEnemy

@export var smoke_scene: PackedScene = preload("res://src/Characters/smoke_explosion/smoke_explosion.tscn")

func initialize():
	$Slime.play_walk()  # Reproduce la animación de caminar al inicializar

func play_hurt_animation():
	$Slime.play_hurt()  # Reproduce la animación de daño cuando el enemigo es golpeado

func play_death_effects():
	# Reproduce los efectos de muerte específicos, como la explosión de humo
	var smoke = smoke_scene.instantiate()
	get_parent().add_child(smoke)
	smoke.global_position = global_position
