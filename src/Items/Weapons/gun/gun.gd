extends GlobalItem

func _init():
	super._init(
		"Gun",
		preload("res://src/Items/Weapons/gun/asset/pistol.png"),
		ItemType.WEAPON,
		preload("res://src/Items/Weapons/gun/bullet.tscn")
	)
	set_stat("damage", 1)
	set_stat("attack_speed", 2.0)
	set_stat("distance_damage", 1)
	print("Gun initialized with name:", name)
