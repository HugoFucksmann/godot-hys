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

	# Agregar los ítems del jugador al GridContainer
	for item in all_items:
		var item_node = item
		if item is PackedScene:
			item_node = item.instantiate()
		add_child(item_node)
		# Conecta la señal de clic para cada ítem
		item_node.connect("gui_input", Callable(self, "_on_item_gui_input").bind(item))
	# Imprimir para depuración
	print("Actualizando grid con ", all_items.size(), " ítems")
	
func _on_item_gui_input(event: InputEvent, item):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		emit_signal("item_pressed", item)
		
func _on_item_pressed(item):
	emit_signal("item_pressed", item)

func get_num_slots():
	return all_items.size()
