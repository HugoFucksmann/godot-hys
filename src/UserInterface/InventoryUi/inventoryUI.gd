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
	inventory_items.all_items.append(item)
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
	inventory_items.update_item_grid()
