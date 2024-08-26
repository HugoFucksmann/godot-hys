extends GlobalItem
class_name GlobalHelmet

@export var defense_boost: float = 0.5

func _ready():
	super._ready()

func use(character):
	# Implementar lógica de uso del casco si es necesario
	pass

func equip(character):
	super.equip(character)
	character.apply_defense_boost(defense_boost)

func unequip(character):
	super.unequip(character)
	character.remove_defense_boost(defense_boost)
