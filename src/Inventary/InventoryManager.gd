extends Node

signal inventory_updated
signal item_equipped(item: GlobalItem, slot: String)
signal item_unequipped(item: GlobalItem, slot: String)

var player_inventory = []
var inventory_slot_scene = preload("res://src/Inventary/InventorySlot.tscn")

@onready var character_equipment = $CharacterEquipment
@onready var inventory_slots_container = $InventoryPanel/SlotsContainer

func _ready():
	DataManager.connect("data_loaded", _on_data_loaded)
	character_equipment.connect("item_equipped", _on_item_equipped)
	character_equipment.connect("item_unequipped", _on_item_unequipped)
	_load_default_items()

func _on_data_loaded():
	player_inventory = DataManager.user_data.get("inventory", [])
	_update_inventory_ui()

func _load_default_items():
	var gun = load("res://src/Items/Weapons/gun/gun.gd").new()
	var red_dragon = load("res://src/Items/Armors/redDragon/redDragon.gd").new()
	add_item_to_inventory(gun)
	add_item_to_inventory(red_dragon)

func add_item_to_inventory(item):
	player_inventory.append(item)
	DataManager.update_inventory(player_inventory)
	emit_signal("inventory_updated")
	_update_inventory_ui()

func remove_item_from_inventory(item):
	var index = player_inventory.find(item)
	if index != -1:
		player_inventory.remove_at(index)
		DataManager.update_inventory(player_inventory)
		emit_signal("inventory_updated")
		_update_inventory_ui()
		return true
	return false

func get_inventory():
	return player_inventory

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
	add_item_to_inventory(item)
