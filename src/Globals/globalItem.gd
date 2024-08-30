extends Area2D
class_name GlobalItem

enum ItemType {ARMA, ARMADURA, BOTAS, CASCO, GUANTES, ACCESORIO}

@export var icon: Texture
@export var item_type: ItemType
@export var bullet_scene: PackedScene
@export var stats: Dictionary = {
	"damage": 0,
	"attack_speed": 0,
	"crit_damage": 0,
	"crit_chance": 0,
	"defense": 0,
	"health": 0,
	"pickup_radius": 0,
	"distance_damage": 0,
	"melee_damage": 0,
	"magic_damage": 0
}

@onready var timer = %Timer
@onready var collision_shape = $CollisionShape2D
@onready var sprite = $Sprite2D
@onready var weapon_sprite = $WeaponPivot/Sprite2D
@onready var shooting_point = %ShootingPoint

func _init(p_name: String = "", p_icon: Texture = null, p_item_type: ItemType = ItemType.ARMA, p_bullet_scene: PackedScene = null):
	name = p_name
	icon = p_icon
	item_type = p_item_type
	bullet_scene = p_bullet_scene

func _ready():
	if not shooting_point:
		print("ShootingPoint no está inicializado.")
	else:
		print("ShootingPoint está listo.")
	update_attack_speed()
	update_collision_shape()
	update_sprites()

func set_stats(p_stats: Dictionary):
	for stat_name in p_stats.keys():
		if stat_name in stats:
			stats[stat_name] = p_stats[stat_name]
	update_attack_speed()
	update_collision_shape()

func get_stat(stat_name: String) -> float:
	return stats.get(stat_name, 0)

func set_bullet_scene(p_bullet_scene: PackedScene):
	bullet_scene = p_bullet_scene

func update_attack_speed():
	if timer:
		timer.wait_time = 1.0 / get_stat("attack_speed")
		timer.start()

func update_collision_shape():
	if collision_shape:
		var shape = CircleShape2D.new()
		shape.radius = get_stat("pickup_radius")
		collision_shape.shape = shape

func update_sprites():
	if sprite:
		sprite.texture = icon
	if weapon_sprite and item_type == ItemType.ARMA:
		weapon_sprite.texture = icon

func _physics_process(delta):
	if item_type == ItemType.ARMA:
		aim_at_nearest_enemy()

func aim_at_nearest_enemy():
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var target_enemy = enemies_in_range.front()
		look_at(target_enemy.global_position)

func shoot():
	if bullet_scene and shooting_point:
		var new_bullet = bullet_scene.instantiate()
		new_bullet.global_position = shooting_point.global_position
		new_bullet.global_rotation = shooting_point.global_rotation
		new_bullet.damage = get_stat("damage")
		get_tree().current_scene.add_child(new_bullet)

func _on_timer_timeout():
	if item_type == ItemType.ARMA:
		shoot()
