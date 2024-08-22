extends Area2D
class_name GlobalItem

signal equipped
signal unequipped

enum ItemType {WEAPON, ARMOR, BOOTS, HELMET, GLOVES, ACCESSORY}

var item_type: ItemType
var item_name: String
var item_power: float
var item_defense: float

func _init():
	pass

# Añadir _ready() aunque no haga nada
func _ready():
	# Método vacío para permitir super._ready() en subclases
	pass

func initialize_item(_item_type: ItemType, _name: String, _power: float, _defense: float):
	item_type = _item_type
	item_name = _name
	item_power = _power
	item_defense = _defense

func equip(character):
	emit_signal("equipped", self)

func unequip(character):
	emit_signal("unequipped", self)

func use(character):
	pass  # Implementar en subclases si es necesario
