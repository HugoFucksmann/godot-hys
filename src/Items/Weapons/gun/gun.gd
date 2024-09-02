extends GlobalWeapon

func _init():
	super._init(
		"Gun",
		preload("res://src/Items/Weapons/gun/asset/pistol.png"),
		ItemType.ARMA,
		preload("res://src/Items/Weapons/gun/bullet.tscn")
	)
	
	set_stats({
		"damage": 1,
		"attack_speed": 200.0,
		"distance_damage": 100,

	})
	add_stats(stats)

func shoot():
	shoot_simple()

func add_stats(stats: Dictionary):
	GlobalState.add_stats(stats)
