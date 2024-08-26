extends GlobalItem
class_name GlobalBoots

@export var movement_speed_boost: float = 1.1
@export var dodge_chance: float = 0.05

func _ready():
	super._ready()

func use(character):
	# Implementar lógica de uso de las botas si es necesario
	pass

func equip(character):
	super.equip(character)
	character.apply_movement_speed_boost(movement_speed_boost)
	character.apply_dodge_chance(dodge_chance)

func unequip(character):
	super.unequip(character)
	character.remove_movement_speed_boost(movement_speed_boost)
	character.remove_dodge_chance(dodge_chance)
