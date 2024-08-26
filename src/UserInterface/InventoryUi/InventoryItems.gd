extends GridContainer
class_name InventoryItems

# Lista de todos los ítems del jugador
var all_items = []

signal item_pressed(item)

func _ready():
	# Conecta la señal item_pressed a _on_item_pressed
	connect("item_pressed", Callable(self, "_on_item_pressed"))

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
		child.queue_free()

	for item in all_items:
		var item_node
		if item is PackedScene:
			item_node = item.instantiate()
		elif item is Node:
			# Eliminar el nodo de su padre anterior antes de agregarlo
			if item.get_parent():
				item.get_parent().remove_child(item)
			item_node = item
		else:
			print("Item no válido:", item)
			continue

		# Crear un contenedor para el ítem
		var item_container = Control.new()
		item_container.custom_minimum_size = Vector2(64, 64)
		item_node.position = item_container.custom_minimum_size / 2
		item_container.add_child(item_node)

		# Agregar el contenedor al GridContainer
		add_child(item_container)
		
func _on_item_gui_input(event: InputEvent, item):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		emit_signal("item_pressed", item)

func _on_item_pressed(item):
	# Realiza aquí las acciones necesarias al presionar el ítem
	# Por ejemplo, mover el ítem a `inventoryPj`
	if item in all_items:
		# Lógica para mover el ítem a `inventoryPj`
		get_tree().call_group("inventoryPj", "_on_item_received", item)
		all_items.erase(item)
		update_item_grid()

func get_num_slots():
	return all_items.size()
