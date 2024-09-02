# globalArmor.gd
extends GlobalItem
class_name GlobalArmor

@onready var armor_sprite = $ArmorSprite

func _ready():
	super._ready()
	update_sprite()

func update_sprite():
	if armor_sprite and item_type == ItemType.ARMADURA:
		armor_sprite.texture = icon

func equip_armor():
	# Aquí puedes añadir cualquier lógica adicional que ocurra al equipar la armadura
	pass

func unequip_armor():
	# Aquí puedes añadir cualquier lógica adicional que ocurra al desequipar la armadura
	pass

func apply_defense():
	# Aplica la defensa de la armadura al personaje
	var defense = get_stat("defense")
	if defense > 0:
		var player = get_parent() # Suponiendo que la armadura se equipa en el player
		if player.has_method("increase_defense"):
			player.increase_defense(defense)
