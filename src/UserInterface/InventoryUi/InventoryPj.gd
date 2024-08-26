class_name InventoryPj
extends Control

signal item_unequipped(item)
# Diccionario para almacenar los ítems equipados
var equipped_items = {
	"weapon": null,
	"armor": null
}

# Lista de ítems del jugador
var player_items = []

signal item_pressed(item)
signal item_list_updated()


func _ready():
	# Conecta la señal de clic para cada slot
	for slot_type in equipped_items.keys():
		var slot_node = get_node_or_null(slot_type)
		if slot_node:
			slot_node.connect("gui_input", _on_slot_clicked.bind(slot_type))

func add_item(item):
	if item is PackedScene or item is Node:
		player_items.append(item)
		emit_signal("item_list_updated")
		emit_signal("item_pressed", item)
	else:
		print("Tipo de item no válido:", item)

func equip_item(slot_type, item):
	# Validar que el slot_type sea válido
	if not equipped_items.has(slot_type):
		print("Error: Tipo de slot no válido: ", slot_type)
		return

		# Desequipar el ítem anterior (si lo hay)
	if equipped_items[slot_type]:
		equipped_items[slot_type].emit_signal("unequipped")
		player_items.append(equipped_items[slot_type])
		emit_signal("item_list_updated")

		# Equipar el nuevo ítem
		print("Intentando equipar item: ", item)
		print("Tipo de item: ", typeof(item))

	if item is PackedScene or item is Node:
		equipped_items[slot_type] = item
	if item.has_method("emit_signal"):
		item.emit_signal("equipped")
		update_inventory_ui()
	else:
		print("Error: El item no es una escena válida ni un nodo")

func update_inventory_ui():
	# Actualizar los slots de la UI con los ítems equipados
	for slot_type in equipped_items:
		update_slot(slot_type, equipped_items[slot_type])

func update_slot(slot_type, item):
	var slot_node = get_node_or_null(slot_type)

	if slot_node == null:
		print("Error: No se pudo encontrar el nodo para el slot ", slot_type)
		return

	for child in slot_node.get_children():
		slot_node.remove_child(child)
		child.queue_free()

	if item:
		var instancia_item
		if item is PackedScene:
			instancia_item = item.instantiate()
		elif item is Node:
			if item.get_parent():
				item.get_parent().remove_child(item)
				instancia_item = item
			else:
				print("Error: El item no es una escena válida ni un nodo")
				return

			instancia_item.scale = Vector2(0.5, 0.5)
			slot_node.add_child(instancia_item)

func _on_slot_clicked(event, slot_type):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if equipped_items[slot_type]:
			emit_signal("item_pressed", equipped_items[slot_type])

func unequip_item(slot_type):
	if equipped_items[slot_type]:
		var item = equipped_items[slot_type]
		equipped_items[slot_type] = null
		update_inventory_ui()
		emit_signal("item_unequipped", item)
		return item
	return null

func _on_item_received(item):
	 # Lógica para manejar el ítem que se recibe desde InventoryItems
	player_items.append(item)
	
	# Llamar a la actualización de la UI
	get_tree().call_group("inventoryUI", "update_item_slots")

func update_item_grid():
	# Limpiar los slots antes de actualizar
	for child in get_children():
		remove_child(child)
		child.queue_free()

	# Actualizar la interfaz con los ítems equipados
	for item in player_items:
		var item_node
		if item is PackedScene:
			item_node = item.instantiate()
		elif item is Node:
			item_node = item
		else:
			print("Item no válido:", item)
			continue

		var item_container = Control.new()
		item_container.custom_minimum_size = Vector2(64, 64)
		item_node.position = item_container.custom_minimum_size / 2
		item_container.add_child(item_node)
		add_child(item_container)
