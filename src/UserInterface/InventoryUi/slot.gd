extends PanelContainer
signal item_pressed


var item = null

func set_item(new_item):
	item = new_item
	# Actualiza la interfaz para mostrar el nuevo ítem (si es necesario)

func get_item():
	return item

