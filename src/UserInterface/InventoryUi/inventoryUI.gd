class_name InventoryUI
extends Control

# Referencia al nodo de Inventory
@onready var inventory: Inventory = get_node(".")

const GlobalWeapon = load()
const GlobalArmor = load()

# Manejar el evento de selección de ítem
func on_item_pressed(item):
		# Determinar el tipo de ítem y asignarlo al slot correspondiente
		if item is GlobalWeapon:
				inventory.equip_item("weapon", item)
		elif item is GlobalArmor:
				inventory.equip_item("armor", item)

		inventory.update_inventory_ui()
