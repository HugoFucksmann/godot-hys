extends GridContainer
class_name InventoryItems

# Lista de todos los ítems del jugador
var all_items = []

signal item_pressed(item)

func _on_equip_pressed(item):
	# Aquí debes implementar la lógica para equipar el ítem
	pass

func _on_delete_pressed(item):
	# Aquí debes implementar la lógica para eliminar el ítem
	pass

func update_item_grid():
	# Limpiar el GridContainer antes de actualizar
	for child in get_children():
		remove_child(child)

	# Agregar los ítems del jugador al GridContainer
	for item in all_items:
		var item_node = item.instantiate()
		add_child(item_node)

func _on_item_pressed(item):
	# Crear los botones "Equipar" y "Eliminar"
	var equip_button = Button.new()
	equip_button.text = "Equipar"
	equip_button.connect("pressed", _on_equip_pressed.bind(item))

	var delete_button = Button.new()
	delete_button.text = "Eliminar"
	delete_button.connect("pressed", _on_delete_pressed.bind(item))

	# Crear un panel para contener los botones
	var button_panel = HBoxContainer.new()
	button_panel.add_child(equip_button)
	button_panel.add_child(delete_button)

	# Emitir la señal de selección de ítem, pero pasando el panel con los botones
	emit_signal("item_pressed", button_panel)

func get_num_slots():
	return all_items.size()
