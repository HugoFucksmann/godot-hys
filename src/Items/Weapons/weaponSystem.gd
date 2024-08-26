# WeaponSystem.gd
extends GlobalItem
class_name WeaponSystem

const BulletSystemScript = preload("res://src/Items/Bullets/BulletSystem.gd")

# Usamos la enumeración de BulletSystem en lugar de definir nuestra propia WeaponType
@export var weapon_type: BulletSystemScript.BulletType
@export var fire_rate: float = 1.0
@export var damage: int = 1

@onready var timer = $Timer
@onready var shooting_point = $WeaponPivot/Pistol/ShootingPoint

func _ready():
	super._ready()
	timer.wait_time = 1.0 / fire_rate
	timer.start()

func _physics_process(delta):
	aim_at_nearest_enemy()

func aim_at_nearest_enemy():
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var target_enemy = enemies_in_range.front()
		look_at(target_enemy.global_position)

func is_enemy_in_range() -> bool:
	var enemies_in_range = get_overlapping_bodies()
	return enemies_in_range.size() > 0

func shoot():
	BulletSystemScript.shoot(weapon_type, shooting_point.global_position, shooting_point.global_rotation, damage)

func _on_timer_timeout():
	if is_enemy_in_range():
		shoot()

func use(character):
	# Implementar lógica de uso del arma si es necesario
	pass
