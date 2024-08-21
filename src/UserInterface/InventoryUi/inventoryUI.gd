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
	
	call_deferred("load_gun")

func add_player_item(item):
	inventoryPj.add_item(item)
	inventory_items.all_items.append(item)
	inventory_items.update_item_grid()
	
func load_gun():
	var area_gun = preload("res://src/Weapons/gun/area_gun.tscn").instantiate()
	add_player_item(area_gun)

func _on_item_pressed(item_and_buttons):
	# Verificar si se recibió un panel con botones
	if item_and_buttons is Control:
		# Conectar las señales de los botones
		item_and_buttons.get_child(0).connect("pressed", inventory_items._on_equip_pressed.bind(item_and_buttons.get_child(0).get_parent()))
		item_and_buttons.get_child(1).connect("pressed", inventory_items._on_delete_pressed.bind(item_and_buttons.get_child(1).get_parent()))
		# Agregar el panel a la interfaz
		add_child(item_and_buttons)
	else:
		# Si no se recibió un panel, asumir que se recibió un ítem
		inventoryPj.equip_item("weapon", item_and_buttons)
		inventoryPj.update_inventory_ui()

func update_item_slots():
	inventory_items.update_item_grid()
