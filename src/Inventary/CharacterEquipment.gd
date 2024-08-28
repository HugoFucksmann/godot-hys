extends Node

signal item_equipped(item: Item, slot: String)
signal item_unequipped(item: Item, slot: String)
signal stats_updated(new_stats: Dictionary)

var equipment = {
	"arma": null,
	"guantes": null,
	"botas": null,
	"armadura": null,
	"casco": null,
	"accesorio": null
}

var base_stats = {
	"ataque": 10,
	"defensa": 5,
	"velocidad": 3
}

@onready var equipment_slots = {
	"arma": $WeaponSlot,
	"guantes": $GlovesSlot,
	"botas": $BootsSlot,
	"armadura": $ArmorSlot,
	"casco": $HelmetSlot,
	"accesorio": $AccessorySlot
}

func _ready():
	for slot in equipment_slots.values():
		slot.connect("gui_input", _on_slot_gui_input.bind(slot))

func equip_item(item: Item) -> bool:
	if item.type in equipment:
		if equipment[item.type]:
			unequip_item(item.type)

		equipment[item.type] = item
		equipment_slots[item.type].texture = item.icon
		emit_signal("item_equipped", item, item.type)
		update_stats()
		return true
	return false

func unequip_item(slot: String) -> Item:
	if slot in equipment and equipment[slot]:
		var item = equipment[slot]
		equipment[slot] = null
		equipment_slots[slot].texture = null
		emit_signal("item_unequipped", item, slot)
		update_stats()
		return item
	return null

func update_stats():
	var total_stats = base_stats.duplicate()

	for item in equipment.values():
		if item:
			for stat in item.stats:
				total_stats[stat] += item.stats[stat]

	emit_signal("stats_updated", total_stats)

func _on_slot_gui_input(event: InputEvent, slot: TextureRect):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var slot_name = equipment_slots.find_key(slot)
		if equipment[slot_name]:
			var unequipped_item = unequip_item(slot_name)
			if unequipped_item:
				GlobalState.add_item_to_inventory(unequipped_item)
