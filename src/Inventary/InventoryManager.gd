extends Node

@onready var character_equipment = $CharacterEquipment
@onready var inventory_slots_container = $InventoryPanel/SlotsContainer
@onready var equip_button = $InventoryPanel/EquipButton

var inventory_slot_scene = preload("res://src/Inventary/InventorySlot.tscn")

func _ready():
	GlobalState.connect("inventory_updated", _on_inventory_updated)
	equip_button.connect("equip_requested", _on_equip_requested)
	character_equipment.connect("item_equipped", _on_item_equipped)
	character_equipment.connect("item_unequipped", _on_item_unequipped)
	character_equipment.connect("stats_updated", _on_stats_updated)
	equip_button.hide()

	_create_inventory_slots()
	_update_inventory_ui()

func _create_inventory_slots():
	for i in range(GlobalState.max_inventory_slots):
		var slot = inventory_slot_scene.instantiate()
		if slot:
			slot.connect("slot_clicked", _on_inventory_slot_clicked)
			print("Slot creado y señal conectada:", slot)
		else:
			print("Error al instanciar el slot.")
		inventory_slots_container.add_child(slot)

func _on_inventory_updated():
	_update_inventory_ui()
	
func _update_inventory_ui():
	var inventory = GlobalState.get_inventory()
	print("Updating inventory UI. Inventory size:", inventory.size())
	for i in range(inventory_slots_container.get_child_count()):
		var slot = inventory_slots_container.get_child(i)
		if i < inventory.size():
			slot.set_item(inventory[i])
			print("Setting item to slot", i, ":", inventory[i].name)
		else:
			slot.set_item(null)
			print("Clearing slot", i)
	print("Inventory update complete")

func _on_inventory_slot_clicked(slot: InventorySlot):
	print("Slot clicked:", slot, "Item:", slot.item)
	if slot.item:
		print("Attempting to equip:", slot.item.name)
		if character_equipment.equip_item(slot.item):
			print("Item equipped successfully")
			GlobalState.remove_item_from_inventory(slot.item)
			_update_inventory_ui()
		else:
			print("Failed to equip item")
	else:
		print("No item in this slot")
	equip_button.hide()

func _on_equip_requested(item: GlobalItem):
	if character_equipment.equip_item(item):
		GlobalState.remove_item_from_inventory(item)
		_update_inventory_ui()
	equip_button.hide()

func _on_item_equipped(item: GlobalItem, slot: String):
	print("Item equipped: ", item.name, " in slot: ", slot)
	_update_inventory_ui()

func _on_item_unequipped(item: GlobalItem, slot: String):
	print("Item unequipped: ", item.name, " from slot: ", slot)
	GlobalState.add_item_to_inventory(item)
	_update_inventory_ui()

func _on_stats_updated(new_stats: Dictionary):
	print("Character stats updated: ", new_stats)
	# Aquí puedes actualizar la UI con los nuevos stats si es necesario
