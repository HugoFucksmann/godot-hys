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
	if player_inventory.is_empty():
		_load_default_items()
	_update_inventory_ui()

func _load_default_items():
	["Gun", "Shotgun", "Basic Armor"].map(func(item_name):
		var item = ItemManager.create_item_by_name(item_name)
		if item:
			add_item_to_inventory(item)
	)

func add_item_to_inventory(item: BaseItem):
	player_inventory.append(item)
	inventory_updated.emit()
	_update_inventory_ui()

func remove_item_from_inventory(item: BaseItem):
	var index = player_inventory.find(item)
	if index != -1:
		player_inventory.remove_at(index)
		inventory_updated.emit()
		_update_inventory_ui()
		return true
	return false

func _update_inventory_ui():
	for child in inventory_slots_container.get_children():
		child.queue_free()
	
	for item in player_inventory:
		var slot = inventory_slot_scene.instantiate()
		if slot:
			slot.connect("slot_clicked", _on_inventory_slot_clicked)
			inventory_slots_container.add_child(slot)
			slot.set_item(item)

func _on_inventory_slot_clicked(slot: InventorySlot):
	if slot.item and character_equipment.equip_item(slot.item):
		remove_item_from_inventory(slot.item)

func _on_item_equipped(item: BaseItem, slot: String):
	GlobalState.equipped_items[slot] = item
	GlobalState.update_equipped_items()

func _on_item_unequipped(item: BaseItem, slot: String):
	GlobalState.equipped_items[slot] = null
	GlobalState.update_equipped_items()
	add_item_to_inventory(item)

func handle_unequipped_item(item: BaseItem):
	add_item_to_inventory(item)
