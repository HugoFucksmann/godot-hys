extends GlobalItem
class_name GlobalWeapon

@onready var weapon_sprite = $WeaponPivot/Pistol
@onready var shooting_point = %ShootingPoint

var current_target: Node2D = null

func _ready():
	super._ready()
	update_sprites()

func update_sprites():
	if weapon_sprite and item_type == ItemType.ARMA:
		weapon_sprite.texture = icon

func _physics_process(delta):
	if item_type == ItemType.ARMA:
		find_and_aim_at_nearest_enemy()

func find_and_aim_at_nearest_enemy():
	var enemies = get_tree().get_nodes_in_group("enemies")
	var nearest_enemy = null
	var nearest_distance = INF

	for enemy in enemies:
		var distance = global_position.distance_to(enemy.global_position)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_enemy = enemy

	if nearest_enemy != current_target:
		current_target = nearest_enemy

	if current_target:
		look_at(current_target.global_position)

func shoot_simple():
	if bullet_scene and shooting_point and current_target:
		var new_bullet = bullet_scene.instantiate()
		new_bullet.global_position = shooting_point.global_position
		new_bullet.global_rotation = global_rotation
		new_bullet.damage = get_stat("damage")
		new_bullet.is_area_damage = false
		get_tree().current_scene.add_child(new_bullet)

func shoot_area():
	if bullet_scene and shooting_point and current_target:
		var new_bullet = bullet_scene.instantiate()
		new_bullet.global_position = shooting_point.global_position
		new_bullet.global_rotation = global_rotation
		new_bullet.damage = get_stat("damage")
		new_bullet.is_area_damage = true
		new_bullet.area_damage_radius = get_stat("area_damage_radius")
		get_tree().current_scene.add_child(new_bullet)

func shoot():
	if item_type == ItemType.ARMA:
		if get_stat("area_damage_radius") > 0:
			shoot_area()
		else:
			shoot_simple()

func _on_timer_timeout():
	shoot()
