extends Area2D

class_name GlobalWeapon


signal equipped
signal unequipped

enum ItemType {WEAPON, ARMOR, BOOTS, HELMET, GLOVES, ACCESSORY}

var item_type: ItemType
var item_name: String
var item_power: float
var item_defense: float

@export var fire_rate: float = 1.0  # Disparos por segundo
@export var bullet_scene: PackedScene
@export var damage: int = 1

@onready var timer = $Timer
@onready var shooting_point = $WeaponPivot/Pistol/ShootingPoint

func _ready():
	
	timer.wait_time = 1.0 / fire_rate
	timer.start()
	

# Método para inicializar los valores del ítem
func initialize_item(_item_type: ItemType, _name: String, _power: float, _defense: float):
	item_type = _item_type
	item_name = _name
	item_power = _power
	item_defense = _defense

func _physics_process(delta):
	aim_at_nearest_enemy()

func aim_at_nearest_enemy():
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var target_enemy = enemies_in_range.front()
		look_at(target_enemy.global_position)

func is_enemy_in_range() -> bool:
	var enemies_in_range = get_overlapping_bodies()
	return enemies_in_range.size() > 0  # Retorna verdadero si hay enemigos


func shoot():
	if bullet_scene:
		var new_bullet = bullet_scene.instantiate()
		new_bullet.global_position = shooting_point.global_position
		new_bullet.global_rotation = shooting_point.global_rotation
		new_bullet.damage = damage
		get_tree().current_scene.add_child(new_bullet)

func _on_timer_timeout():
	if is_enemy_in_range():  # Verifica si hay enemigos en rango
		shoot()
