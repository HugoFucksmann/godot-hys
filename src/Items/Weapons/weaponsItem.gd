class_name WeaponSystem2

class LightningWand extends GlobalWeapon:
	func _init():
		super._init()
		initialize_item(ItemType.WEAPON, "Lightning Wand", {
			"magic_attack": 25,
			"crit_chance": 0.1,
			"crit_damage": 1.5,
			"pickup_radius": 1
		})
		fire_rate = 1.5
		bullet_scene = preload("res://src/Items/Weapons/gun/bullet.tscn")

class SniperRifle extends GlobalWeapon:
	func _init():
		super._init()
		initialize_item(ItemType.WEAPON, "Sniper Rifle", {
			"ranged_attack": 40,
			"crit_chance": 0.2,
			"crit_damage": 2.0
		})
		fire_rate = 0.5
		bullet_scene = preload("res://src/Items/Weapons/gun/bullet.tscn")

class FlamingSword extends GlobalWeapon:
	func _init():
		super._init()
		initialize_item(ItemType.WEAPON, "Flaming Sword", {
			"melee_attack": 30,
			"magic_attack": 10,
			"crit_chance": 0.15,
			"crit_damage": 1.75
		})
		fire_rate = 2.0
		bullet_scene = preload("res://src/Items/Weapons/gun/bullet.tscn")
