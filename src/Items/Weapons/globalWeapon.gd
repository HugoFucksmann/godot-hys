extends GlobalItem
class_name GlobalWeapon

@export var fire_rate: float = 1.0  # Disparos por segundo
@export var bullet_scene: PackedScene
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
	if bullet_scene:
		var new_bullet = bullet_scene.instantiate()
		new_bullet.global_position = shooting_point.global_position
		new_bullet.global_rotation = shooting_point.global_rotation
		new_bullet.damage = damage
		get_tree().current_scene.add_child(new_bullet)

func _on_timer_timeout():
	if is_enemy_in_range():
		shoot()

# Sobreescribimos el método use para implementar la lógica específica del arma
func use(character):
	# Implementar lógica de uso del arma si es necesario
	pass
