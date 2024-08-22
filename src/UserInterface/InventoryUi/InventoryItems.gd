extends GridContainer
class_name InventoryItems

# Lista de todos los ítems del jugador
var all_items = []

signal item_pressed(item)

func _on_equip_pressed(item):
	# Implementar la lógica para equipar el ítem
	emit_signal("item_pressed", item)

func _on_delete_pressed(item):
	# Implementar la lógica para eliminar el ítem
	pass

func update_item_grid():
	# Limpiar el GridContainer antes de actualizar
	for child in get_children():
		remove_child(child)

	# Agregar los ítems del jugador al GridContainer
	for item in all_items:
		var item_node = item
		add_child(item_node)

func _on_item_pressed(item):
	emit_signal("item_pressed", item)

func get_num_slots():
	return all_items.size()
