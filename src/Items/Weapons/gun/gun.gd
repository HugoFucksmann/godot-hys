extends GlobalWeapon

func _init():
	super._init(
		"Gun",
		preload("res://src/Items/Weapons/gun/asset/pistol.png"),
		ItemType.ARMA,
		preload("res://src/Items/Weapons/gun/bullet.tscn")
	)
	
	set_stats({
		"damage": 100,
		"attack_speed": 2.0,
		"distance_damage": 1,
		"pickup_radius": 50
	})

func shoot():
	shoot_simple()
