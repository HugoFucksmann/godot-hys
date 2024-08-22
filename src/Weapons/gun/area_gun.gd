extends GlobalWeapon
class_name AreaGun
func _init():
	fire_rate = 2.0
	damage = 1
	bullet_scene = preload("res://src/Weapons/gun/bullet.tscn")
	initialize_item(ItemType.WEAPON, "Pistol", 50.0, 0.0)
