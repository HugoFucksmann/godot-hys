extends GlobalItem

func _init():
	super._init(
		"Gun",
		preload("res://src/Items/Weapons/gun/asset/pistol.png"),
		ItemType.ARMA
	)
	
	set_stats({
		"damage": 1,
		"attack_speed": 2.0,
		"distance_damage": 1,
		"pickup_radius": 50  # Añade esto para personalizar el radio de colisión
	})

	set_bullet_scene(preload("res://src/Items/Weapons/gun/bullet.tscn"))
	print("Gun initialized with name:", name)
