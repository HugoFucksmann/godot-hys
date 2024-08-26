extends Area2D
class_name GlobalItem

signal equipped
signal unequipped

enum ItemType {WEAPON, ARMOR, BOOTS, HELMET, GLOVES, ACCESSORY}

var item_type: ItemType
var item_name: String
var max_health: float = 0
var armor: float = 0
var pickup_radius: float = 0
var crit_chance: float = 0
var crit_damage: float = 0
var ranged_attack: float = 0
var melee_attack: float = 0
var magic_attack: float = 0

func _init():
	pass

# Añadir _ready() aunque no haga nada
func _ready():
	# Método vacío para permitir super._ready() en subclases
	pass

func initialize_item(_item_type: ItemType, _name: String, stats: Dictionary):
	item_type = _item_type
	item_name = _name
	max_health = stats.get("max_health", 0)
	armor = stats.get("armor", 0)
	pickup_radius = stats.get("pickup_radius", 0)
	crit_chance = stats.get("crit_chance", 0)
	crit_damage = stats.get("crit_damage", 0)
	ranged_attack = stats.get("ranged_attack", 0)
	melee_attack = stats.get("melee_attack", 0)
	magic_attack = stats.get("magic_attack", 0)


func equip(character):
	emit_signal("equipped", self)

func unequip(character):
	emit_signal("unequipped", self)

func use(character):
	pass  # Implementar en subclases si es necesario
