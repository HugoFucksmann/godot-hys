extends Area2D
class_name GlobalItem

enum ItemType {WEAPON, ARMOR, BOOTS, HELMET, GLOVES, ACCESSORY}


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

func _init(p_name: String = "", p_icon: Texture = null, p_item_type: ItemType = ItemType.WEAPON, p_bullet_scene: PackedScene = null):
	name = p_name
	icon = p_icon
	item_type = p_item_type
	bullet_scene = p_bullet_scene

func set_stat(stat_name: String, value: float):
	if stat_name in stats:
		stats[stat_name] = value

func get_stat(stat_name: String) -> float:
	return stats.get(stat_name, 0)
