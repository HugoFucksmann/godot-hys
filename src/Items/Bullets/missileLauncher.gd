extends GlobalItem

func _init():
	super._init(
		"Missile Launcher",
	   	preload("res://src/Items/Weapons/gun/asset/pistol.png"),
		ItemType.ARMA,
		preload("res://src/Items/Weapons/gun/bullet.tscn")
	)
	
	set_stats({
		"damage": 5,
		"attack_speed": 0.5,
		"distance_damage": 5,
		"pickup_radius": 50,
		"area_damage_radius": 100
	})

func shoot():
	shoot_area()
