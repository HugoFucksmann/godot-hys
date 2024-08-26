# area_gun.gd
extends WeaponSystem
class_name AreaGun

@export var current_weapon_type: String = "NORMAL":
	set(new_type):
		current_weapon_type = new_type.to_upper()
		update_weapon_properties()

func _ready():
	super._ready()
	update_weapon_properties()

func update_weapon_properties():
	weapon_type = BulletSystem.BulletType[current_weapon_type]
	match weapon_type:
		BulletSystem.BulletType.LASER:
			fire_rate = 0.5
			damage = 2
		BulletSystem.BulletType.SNIPER:
			fire_rate = 2.0
			damage = 5
		BulletSystem.BulletType.FLAMING:
			fire_rate = 0.2
			damage = 1
		BulletSystem.BulletType.AREA:
			fire_rate = 1.0
			damage = 3
		BulletSystem.BulletType.NORMAL:
			fire_rate = 1.0
			damage = 1
		BulletSystem.BulletType.SHOTGUN:
			fire_rate = 1.5
			damage = 1
	
	if timer:
		timer.wait_time = 1.0 / fire_rate

func shoot():
	BulletSystem.shoot(weapon_type, global_position, global_rotation, damage)
