extends GlobalWeapon

func _init():
	super._init(
		"Gun",
		preload("res://src/Items/Weapons/gun/asset/pistol.png"),
		ItemType.ARMA,
		preload("res://src/Items/Bullets/bullet.tscn")
	)
	
	set_stats({
		"damage": 1,
		"attack_speed": 200.0,
		"distance_damage": 100,
	})

func shoot():
	shoot_simple()
