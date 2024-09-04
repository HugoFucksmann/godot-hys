extends Resource
class_name BaseItem

enum ItemType {ARMA, ARMADURA, BOTAS, CASCO, GUANTES, ACCESORIO}

@export var name: String = ""
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

func _init(p_name: String = "", p_icon: Texture = null, p_item_type: ItemType = ItemType.ARMA, p_bullet_scene: PackedScene = null):
	name = p_name
	icon = p_icon
	item_type = p_item_type
	bullet_scene = p_bullet_scene

func set_stats(p_stats: Dictionary):
	stats = p_stats

func get_stat(stat_name: String) -> float:
	return stats.get(stat_name, 0.0)
