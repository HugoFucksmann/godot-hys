extends Node

@onready var character_equipment = $CharacterEquipment
@onready var inventory_slots_container = $InventoryPanel/SlotsContainer
@onready var equip_button = $InventoryPanel/EquipButton

var inventory_slot_scene = preload("res://src/Inventary/InventorySlot.tscn")

func _ready():
	GlobalState.connect("inventory_updated", _on_inventory_updated)
	equip_button.connect("equip_requested", _on_equip_requested)
	equip_button.hide()
	
	_create_inventory_slots()
	_update_inventory_ui()

func _create_inventory_slots():
	for i in range(GlobalState.max_inventory_slots):
		var slot = inventory_slot_scene.instantiate()
		slot.connect("slot_clicked", _on_inventory_slot_clicked)
		inventory_slots_container.add_child(slot)

func _on_inventory_updated():
	_update_inventory_ui()

func _update_inventory_ui():
	var inventory = GlobalState.get_inventory()
	for i in range(inventory_slots_container.get_child_count()):
		var slot = inventory_slots_container.get_child(i)
		if i < inventory.size():
			slot.set_item(inventory[i])
		else:
			slot.set_item(null)

func _on_inventory_slot_clicked(slot: InventorySlot):
	if slot.item:
		equip_button.set_item(slot.item)
		equip_button.show()
	else:
		equip_button.hide()

func _on_equip_requested(item: GlobalItem):
	if character_equipment.equip_item(item):
		GlobalState.remove_item_from_inventory(item)
	equip_button.hide()
