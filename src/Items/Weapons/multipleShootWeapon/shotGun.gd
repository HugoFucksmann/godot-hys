extends GlobalItem

const BULLET_SPREAD = 30  # Ángulo total del cono de disparo en grados
const BULLET_COUNT = 5

func _init():
	super._init(
		"Shotgun",
		preload("res://src/Items/Weapons/gun/asset/pistol.png"),
		ItemType.ARMA
	)
	
	set_stats({
		"damage": 0.5,  # Daño por bala, menor que la pistola normal
		"attack_speed": 1.0,
		"distance_damage": 0.5,
		"pickup_radius": 50
	})

	set_bullet_scene(preload("res://src/Items/Weapons/gun/bullet.tscn"))

func shoot():
	if bullet_scene and shooting_point:
		for i in range(BULLET_COUNT):
			var new_bullet = bullet_scene.instantiate()
			new_bullet.global_position = shooting_point.global_position
			
			# Calcula el ángulo para cada bala dentro del cono
			var spread_angle = deg_to_rad(BULLET_SPREAD)
			var bullet_angle = spread_angle * (float(i) / (BULLET_COUNT - 1) - 0.5)
			new_bullet.global_rotation = shooting_point.global_rotation + bullet_angle
			
			new_bullet.damage = get_stat("damage")
			get_tree().current_scene.add_child(new_bullet)
