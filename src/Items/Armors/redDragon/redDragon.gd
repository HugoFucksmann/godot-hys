# dragonRojo.gd
extends GlobalArmor

func _init():
	super._init(
		"Dragon Rojo",
		preload("res://src/Items/Armors/redDragon/assets/redDragonArmor.png"),
		ItemType.ARMADURA,
		null  # No se necesita una escena de bullet para la armadura
	)
	
	set_stats({
		"defense": 50,
		"health": 200,
		"pickup_radius": 30,
	})

func equip_armor():
	apply_defense()
	# Lógica adicional específica para la armadura "Dragon Rojo", si aplica
