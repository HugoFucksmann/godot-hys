extends Area2D
class_name GlobalItem

enum ItemType {ARMA, ARMADURA, BOTAS, CASCO, GUANTES, ACCESORIO}

@export var icon: Texture
@export var item_type: ItemType
@export var weapon_scene: PackedScene  # Nueva propiedad para la escena del arma
@export var bullet_scene: PackedScene
@export var stats: Dictionary = {
	"damage": 0,
	"attack_speed": 0.0,
	"crit_damage": 0.0,
	"crit_chance": 0.0,
	"defense": 0,
	"health": 0,
	"pickup_radius": 0,
	"distance_damage": 0.0,
	"melee_damage": 0.0,
	"magic_damage": 0.0,
	"area_damage_radius": 0.0
}

@onready var collision_shape = $CollisionShape2D

func _init(name: String = "", p_icon: Texture = null, p_item_type: ItemType = ItemType.ARMA, p_weapon_scene: PackedScene = null, p_bullet_scene: PackedScene = null):
	self.name = name
	icon = p_icon
	item_type = p_item_type
	weapon_scene = p_weapon_scene  # Agrega la escena del arma
	bullet_scene = p_bullet_scene

func _ready():
	update_collision_shape()

func set_stats(p_stats: Dictionary):
	stats = p_stats
	update_collision_shape()

func get_stat(stat_name: String) -> float:
	return stats.get(stat_name, 0.0)

func update_collision_shape():
	if collision_shape:
		var shape = CircleShape2D.new()
		shape.radius = get_stat("pickup_radius")
		collision_shape.shape = shape
