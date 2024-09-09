extends Resource
class_name BaseItem

enum ItemType {ARMA, GUANTES, BOTAS, ARMADURA, CASCO, ACCESORIO}

@export var name: String
@export var icon: Texture
@export var item_type: ItemType
@export var stats: Dictionary

func _init(_name: String = "", _icon: Texture = null, _item_type: ItemType = ItemType.ARMA):
	name = _name
	icon = _icon
	item_type = _item_type
	stats = {}

func set_stats(_stats: Dictionary):
	stats = _stats

func get_stat(stat_name: String, default_value = null):
	return stats.get(stat_name, default_value)

func to_dict() -> Dictionary:
	return {
		"name": name,
		"icon": icon.resource_path if icon else "",
		"item_type": item_type,
		"stats": stats
	}
