extends GlobalWeapon
class_name AreaGun

func _init():
	super._init()
	fire_rate = 2.0
	damage = 1
	bullet_scene = preload("res://src/Weapons/gun/bullet.tscn")
	initialize_item(ItemType.WEAPON, "Pistol", 50.0, 0.0)

# Puedes sobrescribir métodos específicos de AreaGun si es necesario
func shoot():
	super.shoot()
	# Agregar lógica adicional específica de AreaGun si es necesario
