extends Node

@onready var character_equipment = $CharacterEquipment
@onready var inventory_slots_container = $InventoryPanel/SlotsContainer

var inventory_slot_scene = preload("res://src/Inventary/InventorySlot.tscn")

func _ready():
	GlobalState.connect("inventory_updated", _on_inventory_updated)
	character_equipment.connect("item_equipped", _on_item_equipped)
	character_equipment.connect("item_unequipped", _on_item_unequipped)
	character_equipment.connect("stats_updated", _on_stats_updated)
	
	_update_inventory_ui()

func _update_inventory_ui():
	print("Updating inventory UI")  # Debug
	for child in inventory_slots_container.get_children():
		inventory_slots_container.remove_child(child)
		child.queue_free()
	
	var inventory = GlobalState.get_inventory()
	for item in inventory:
		var slot = inventory_slot_scene.instantiate()
		if slot:
			slot.connect("slot_clicked", _on_inventory_slot_clicked)
			inventory_slots_container.add_child(slot)
			slot.set_item(item)
	
	var empty_slots = GlobalState.max_inventory_slots - inventory.size()
	for i in range(empty_slots):
		var slot = inventory_slot_scene.instantiate()
		if slot:
			slot.connect("slot_clicked", _on_inventory_slot_clicked)
			inventory_slots_container.add_child(slot)
			slot.set_item(null)

	print("Inventory UI updated, total slots: ", inventory_slots_container.get_child_count())  # Debug

func _on_inventory_updated():
	_update_inventory_ui()

func _on_inventory_slot_clicked(slot: InventorySlot):
	if slot.item:
		print("Attempting to equip item: ", slot.item.name)  # Debug
		if character_equipment.equip_item(slot.item):
			print("Item equipped successfully, removing from inventory")  # Debug
			GlobalState.remove_item_from_inventory(slot.item)
			_update_inventory_ui()

func _on_item_equipped(item: GlobalItem, slot: String):
	print("Item equipped: ", item.name, " in slot: ", slot)  # Debug
	_update_inventory_ui()

func _on_item_unequipped(item: GlobalItem, slot: String):
	print("Item unequipped: ", item.name, " from slot: ", slot)  # Debug
	# Evitamos agregar el item al inventario aquí, ya que se manejará en GlobalState
	_update_inventory_ui()

func _on_stats_updated(new_stats: Dictionary):
	print("Character stats updated: ", new_stats)
