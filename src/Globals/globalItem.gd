extends Area2D
class_name GlobalItem

enum ItemType {ARMA, ARMADURA, BOTAS, CASCO, GUANTES, ACCESORIO}

@export var icon: Texture
@export var item_type: ItemType
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


func _init(p_name: String = "", p_icon: Texture = null, p_item_type: ItemType = ItemType.ARMA, p_bullet_scene: PackedScene = null):
	name = p_name
	icon = p_icon
	item_type = p_item_type
	bullet_scene = p_bullet_scene

func _ready():
	update_collision_shape()

func set_stats(p_stats: Dictionary):
	for stat_name in p_stats.keys():
		if stat_name in stats:
			stats[stat_name] = p_stats[stat_name]
	update_collision_shape()

func get_stat(stat_name: String) -> float:
	return StatsManager.get_stat(stat_name)

func update_collision_shape():
	if collision_shape:
		var shape = CircleShape2D.new()
		shape.radius = get_stat("pickup_radius")
		collision_shape.shape = shape
