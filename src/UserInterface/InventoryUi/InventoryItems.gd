extends GridContainer
class_name InventoryItems

# Lista de todos los ítems del jugador
var all_items = []

signal item_pressed(item)

func update_item_grid():
	# Limpiar el GridContainer antes de actualizar
	for child in $ItemGrid.get_children():
		$ItemGrid.remove_child(child)

	# Agregar los ítems del jugador al GridContainer
	for item in all_items:
		var item_node = item.instantiate()
		$ItemGrid.add_child(item_node)

	# Asegurarnos de que haya 12 slots, incluyendo los vacíos
	while $ItemGrid.get_child_count() < 12:
		var empty_slot = Control.new()
		$ItemGrid.add_child(empty_slot)
		
func _on_item_pressed(item):
	# Emitir la señal de selección de ítem hacia el InventoryUI
	emit_signal("item_pressed", item)
