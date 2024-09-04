extends Node

signal inventory_updated
signal item_equipped(item: GlobalItem, slot: String)
signal item_unequipped(item: GlobalItem, slot: String)
signal inventory_changed

var player_inventory = []
var inventory_slot_scene = preload("res://src/Inventary/InventorySlot.tscn")

@onready var character_equipment = $CharacterEquipment
@onready var inventory_slots_container = $InventoryPanel/SlotsContainer

func _ready():
	DataManager.connect("data_loaded", _on_data_loaded)
	character_equipment.connect("item_equipped", _on_item_equipped)
	character_equipment.connect("item_unequipped", _on_item_unequipped)
	GlobalState.connect("equipped_items_updated", _update_inventory_ui)
	connect("inventory_changed", _update_inventory_ui)
	_load_default_items()

func _on_data_loaded():
	player_inventory = []
	var loaded_inventory = DataManager.user_data.get("inventory", [])
	for item_data in loaded_inventory:
		var item = GlobalState.create_item_from_data(item_data)
		player_inventory.append(item)
	_update_inventory_ui()

func _load_default_items():
	var gun = GlobalItem.new("Gun", load("res://path/to/gun_icon.png"), GlobalItem.ItemType.ARMA)
	var red_dragon = GlobalItem.new("Red Dragon", load("res://path/to/red_dragon_icon.png"), GlobalItem.ItemType.ARMADURA)
	add_item_to_inventory(gun)
	add_item_to_inventory(red_dragon)

func add_item_to_inventory(item):
	player_inventory.append(item)
	DataManager.update_inventory(get_inventory_save_data())
	emit_signal("inventory_changed")

func remove_item_from_inventory(item):
	var index = player_inventory.find(item)
	if index != -1:
		player_inventory.remove_at(index)
		DataManager.update_inventory(get_inventory_save_data())
		emit_signal("inventory_changed")
		return true
	return false

func get_inventory():
	return player_inventory

func get_inventory_save_data():
	var inventory_data = []
	for item in player_inventory:
		inventory_data.append(item.get_save_data())
	return inventory_data

func _update_inventory_ui():
	for child in inventory_slots_container.get_children():
		inventory_slots_container.remove_child(child)
		child.queue_free()
	
	for item in player_inventory:
		var slot = inventory_slot_scene.instantiate()
		if slot:
			slot.connect("slot_clicked", _on_inventory_slot_clicked)
			inventory_slots_container.add_child(slot)
			slot.set_item(item)
	
	# Actualizar la UI de los items equipados
	for slot in GlobalState.equipped_items:
		var item = GlobalState.equipped_items[slot]
		if item and item is GlobalItem:
			character_equipment.update_slot_texture(slot, item.icon)
		else:
			character_equipment.update_slot_texture(slot, null)

func _on_inventory_slot_clicked(slot: InventorySlot):
	if slot.item:
		if character_equipment.equip_item(slot.item):
			remove_item_from_inventory(slot.item)

func _on_item_equipped(item: GlobalItem, slot: String):
	GlobalState.equipped_items[slot] = item
	GlobalState.update_equipped_items()
	StatsManager.update_total_stats()

func _on_item_unequipped(item: GlobalItem, slot: String):
	GlobalState.equipped_items[slot] = null
	GlobalState.update_equipped_items()
	add_item_to_inventory(item)
	StatsManager.update_total_stats()

func handle_unequipped_item(item):
	if not player_inventory.has(item):
		add_item_to_inventory(item)
