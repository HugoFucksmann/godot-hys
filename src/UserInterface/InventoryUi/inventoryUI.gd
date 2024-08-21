class_name InventoryUI
extends Node2D

@onready var CharacterView: Control = $CharacterView
@onready var ItemListView: Control = $ItemListView
@onready var inventoryPj: InventoryPj = $CharacterView/InventoryPj
@onready var inventory_items: InventoryItems = $ItemListView/InventoryItems

func add_player_item(item):
	inventoryPj.add_item(item)
	update_item_slots()

func _ready():
	var area_gun = preload("res://src/Weapons/gun/area_gun.tscn").instantiate()
	add_player_item(area_gun)
	add_player_item(area_gun)
	inventoryPj.connect("item_pressed", _on_item_pressed)
	inventoryPj.connect("item_list_updated", update_item_slots)
	update_item_slots()

func _on_item_pressed(item):
	inventoryPj.equip_item("weapon", item)
	inventoryPj.update_inventory_ui()

func update_item_slots():
	# Limpiar los slots antes de actualizar
	for child in inventory_items.get_children():
		inventory_items.remove_child(child)

	# Agregar los ítems del jugador a los slots
	for item in inventoryPj.player_items:
		var item_button = Button.new()
		item_button.text = item.name
		item_button.connect("pressed", _on_item_pressed.bind(item))
		inventory_items.add_child(item_button)
