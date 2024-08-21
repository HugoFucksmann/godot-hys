class_name InventoryPj
extends Control

# Diccionario para almacenar los ítems equipados
var equipped_items = {
	"weapon": null,
	"armor": null
}

# Lista de ítems del jugador
var player_items = []

signal item_pressed(item)
signal item_list_updated()

func add_item(item):
	player_items.append(item)
	emit_signal("item_list_updated")
	emit_signal("item_pressed", item)

func equip_item(slot_type, item):
	# Desequipar el ítem anterior (si lo hay)
	if equipped_items[slot_type]:
		equipped_items[slot_type].emit_signal("unequipped")
	# Equipar el nuevo ítem
	equipped_items[slot_type] = item
	item.emit_signal("equipped")
	update_inventory_ui()

func update_inventory_ui():
	# Actualizar los slots de la UI con los ítems equipados
	for slot_type in equipped_items:
		if equipped_items[slot_type]:
			update_slot(slot_type, equipped_items[slot_type])
		else:
			update_slot(slot_type, null)

func update_slot(slot_type, item):
	# Obtener una referencia al nodo que representa el slot
	var slot_node = get_node(slot_type)
	
	# Limpiar el slot
	for child in slot_node.get_children():
		slot_node.remove_child(child)
	
	# Si hay un ítem equipado, agregarlo al slot
	if item:
		var item_label = Label.new()
		item_label.text = item.name
		slot_node.add_child(item_label)
	# Si no hay ítem equipado, dejar el slot vacío
