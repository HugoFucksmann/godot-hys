extends GlobalItem
class_name GlobalGloves

@export var attack_speed_boost: float = 0.1
@export var damage_boost: float = 1.0

func _ready():
	super._ready()

func use(character):
	# Implementar lógica de uso de los guantes si es necesario
	pass

func equip(character):
	super.equip(character)
	character.apply_attack_speed_boost(attack_speed_boost)
	character.apply_damage_boost(damage_boost)

func unequip(character):
	super.unequip(character)
	character.remove_attack_speed_boost(attack_speed_boost)
	character.remove_damage_boost(damage_boost)
