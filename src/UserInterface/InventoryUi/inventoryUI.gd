class_name InventoryUI
extends Node2D

@onready var CharacterView: Control = $CharacterView 
@onready var ItemListView: Control = $ItemListView 
@onready var inventoryPj: InventoryPj = $CharacterView/InventoryPj 
@onready var inventory_items: InventoryItems = $ItemListView/InventoryItems


func _ready():
	if inventoryPj == null or inventory_items == null:
		print("Inventory nodes are null")
		return
	inventoryPj.connect("item_pressed", _on_item_pressed)
	inventoryPj.connect("item_list_updated", update_item_slots)
	update_item_slots()
	inventoryPj.connect("item_unequipped", _on_item_unequipped)
	call_deferred("add_gun_to_inventory")

func _on_item_unequipped(item):
	inventory_items.all_items.append(item)
	inventory_items.update_item_grid()
	
func add_player_item(item):
	print("Añadiendo item al inventario")
	inventoryPj.add_item(item)
	
	# Si el item es una escena empaquetada, añadirla directamente
	if item is PackedScene:
		inventory_items.all_items.append(item)
	# Si es un nodo instanciado, añadirlo directamente
	elif item is Node:
		inventory_items.all_items.append(item)
	else:
		print("Tipo de item no reconocido:", item)
	
	inventory_items.update_item_grid()
	print("Número de ítems en inventory_items: ", inventory_items.all_items.size())

func add_gun_to_inventory():
	var area_gun_scene = preload("res://src/Weapons/gun/area_gun.tscn")
	var area_gun = area_gun_scene.instantiate()
	add_player_item(area_gun)

func _on_item_pressed(item):
	print("Item clicked:", item)  # Para depuración
	if item in inventoryPj.equipped_items.values():
		show_unequip_dialog(item)
	elif item in inventory_items.all_items:
		show_equip_dialog(item)
	else:
		print("Item not found in inventory")  # Para depuración

func show_equip_dialog(item):
	var dialog = AcceptDialog.new()
	dialog.dialog_text = "¿Quieres equipar este ítem?"
	dialog.connect("confirmed", Callable(self, "_on_equip_confirmed").bind(item))
	add_child(dialog)
	dialog.popup_centered()
	print("Showing equip dialog for item:", item)  # Para depuración
	
func show_unequip_dialog(item):
	var dialog = AcceptDialog.new()
	dialog.dialog_text = "¿Quieres desequipar este ítem?"
	dialog.connect("confirmed", Callable(self, "_on_unequip_confirmed").bind(item))
	add_child(dialog)
	dialog.popup_centered()

func _on_equip_confirmed(item):
	for slot_type in inventoryPj.equipped_items.keys():
		if inventoryPj.equipped_items[slot_type] == null:
			inventoryPj.equip_item(slot_type, item)
			inventory_items.all_items.erase(item)
			inventory_items.update_item_grid()
			break
	
func _on_unequip_confirmed(item):
	for slot_type in inventoryPj.equipped_items.keys():
		if inventoryPj.equipped_items[slot_type] == item:
			inventoryPj.unequip_item(slot_type)
			break
	
func update_item_slots():
	# Actualiza la UI de InventoryItems
	inventory_items.update_item_grid()

	# Actualiza la UI de InventoryPj
	inventoryPj.update_item_grid()

func update_item_grid():
	# Actualizar la UI de InventoryItems
	_update_inventory_items()
	
	# Actualizar la UI de InventoryPj
	_update_inventory_pj()

func _update_inventory_items():
	# Limpiar el GridContainer de InventoryItems antes de actualizar
	inventory_items.clear()

	for item in inventory_items.all_items:
		var item_node
		if item is PackedScene:
			item_node = item.instantiate()
		elif item is Node:
			if item.get_parent():
				item.get_parent().remove_child(item)
				item_node = item
			else:
				continue
		
		var item_container = Control.new()
		item_container.custom_minimum_size = Vector2(64, 64)
		item_node.position = item_container.custom_minimum_size / 2
		item_container.add_child(item_node)
		inventory_items.add_child(item_container)

func _update_inventory_pj():
	# Limpiar el GridContainer de InventoryPj antes de actualizar
	inventoryPj.clear()

	for item in inventoryPj.player_items:
		var item_node
		if item is PackedScene:
			item_node = item.instantiate()
		elif item is Node:
			if item.get_parent():
				item.get_parent().remove_child(item)
				item_node = item
			else:
				continue

		var item_container = Control.new()
		item_container.custom_minimum_size = Vector2(64, 64)
		item_node.position = item_container.custom_minimum_size / 2
		item_container.add_child(item_node)
		inventoryPj.add_child(item_container)
