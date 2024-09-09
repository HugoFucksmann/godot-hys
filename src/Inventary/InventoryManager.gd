extends Node

signal inventory_updated
signal item_equipped(item: BaseItem, slot: String)
signal item_unequipped(item: BaseItem, slot: String)

var player_inventory = []
var inventory_slot_scene = preload("res://src/Inventary/InventorySlot.tscn")

@onready var character_equipment = $CharacterEquipment
@onready var inventory_slots_container = $InventoryPanel/SlotsContainer

func _ready():
	character_equipment.connect("item_equipped", _on_item_equipped)
	character_equipment.connect("item_unequipped", _on_item_unequipped)
	_load_inventory()
	character_equipment.load_equipped_items()
	
func _load_inventory():
	# Here you should implement logic to load the inventory from a saved state
	# For now, we'll just load default items if the inventory is empty
	if player_inventory.is_empty():
		_load_default_items()
	_update_inventory_ui()

func _load_default_items():
	var gun = ItemManager.create_item_by_name("Gun")
	var gloves = ItemManager.create_item_by_name("Shotgun")
	var armor = ItemManager.create_item_by_name("Basic Armor")
	add_item_to_inventory(gun)
	add_item_to_inventory(gloves)
	add_item_to_inventory(armor)

func _load_equipped_items():
	for slot in GlobalState.equipped_items.keys():
		var item_data = GlobalState.equipped_items[slot]
		if item_data:
			var item = ItemManager.create_item_from_data(item_data)
			if item:
				character_equipment.equip_item(item)

func add_item_to_inventory(item: BaseItem):
	player_inventory.append(item)
	emit_signal("inventory_updated")
	_update_inventory_ui()

func remove_item_from_inventory(item: BaseItem):
	var index = player_inventory.find(item)
	if index != -1:
		player_inventory.remove_at(index)
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

func _on_item_equipped(item: BaseItem, slot: String):
	GlobalState.equipped_items[slot] = item
	GlobalState.update_equipped_items()
	StatsManager.update_total_stats()

func _on_item_unequipped(item: BaseItem, slot: String):
	GlobalState.equipped_items[slot] = null
	GlobalState.update_equipped_items()
	add_item_to_inventory(item)
	StatsManager.update_total_stats()

func handle_unequipped_item(item: BaseItem):
	add_item_to_inventory(item)
