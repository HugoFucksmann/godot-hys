extends GlobalItem
class_name GlobalAccessory

@export var special_effect: String = ""
@export var effect_power: float = 1.0

func _ready():
	super._ready()

func use(character):
	# Implementar lógica de uso del accesorio si es necesario
	pass

func equip(character):
	super.equip(character)
	character.apply_special_effect(special_effect, effect_power)

func unequip(character):
	super.unequip(character)
	character.remove_special_effect(special_effect)
