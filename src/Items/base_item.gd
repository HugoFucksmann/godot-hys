extends Resource
class_name BaseItem

enum ItemType {ARMA, GUANTES, BOTAS, ARMADURA, CASCO, ACCESORIO}

@export var name: String
@export var icon: Texture
@export var item_type: ItemType
@export var bullet_scene: PackedScene
@export var stats: Dictionary

func _init(_name: String = "", _icon: Texture = null, _item_type: ItemType = ItemType.ARMA, _bullet_scene: PackedScene = null):
	name = _name
	icon = _icon
	item_type = _item_type
	bullet_scene = _bullet_scene
	stats = {}

func set_stats(_stats: Dictionary):
	stats = _stats

func to_dict() -> Dictionary:
	return {
		"name": name,
		"icon": icon.resource_path if icon else "",
		"item_type": item_type,
		"bullet_scene": bullet_scene.resource_path if bullet_scene else "",
		"stats": stats
	}
