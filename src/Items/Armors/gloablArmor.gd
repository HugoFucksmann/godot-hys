extends GlobalItem
class_name GlobalArmor

@export var defense_boost: float = 1.0

func _ready():
	super._ready()

func use(character):
	# Implementar lógica de uso de la armadura si es necesario
	pass

# Sobrescribir equip para aplicar la defensa al personaje
func equip(character):
	super.equip(character)
	character.apply_defense_boost(defense_boost)

# Sobrescribir unequip para quitar la defensa al personaje
func unequip(character):
	super.unequip(character)
	character.remove_defense_boost(defense_boost)
