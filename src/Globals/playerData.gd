extends Node

signal score_updated
signal player_died

signal equipment_changed
signal inventory_changed

var equipped_items = {
	"weapon": null,
	"armor": null,
	"boots": null,
	"helmet": null,
	"gloves": null,
	"accessory": null
}

var inventory_items = []

var score: = 0
var deaths: = 0 

func reset() -> void:
	score = 0
	deaths = 0


func set_score(value: int) -> void:
	score = value
	emit_signal("score_updated")
	
func set_deaths(value: int) -> void:
	score = value
	emit_signal("player_died")

func _ready() -> void:
	set_score(score)
	set_deaths(deaths)

func equip_item(slot_type: String, item):
	if slot_type in equipped_items:
		if equipped_items[slot_type]:
			inventory_items.append(equipped_items[slot_type])
		equipped_items[slot_type] = item
		inventory_items.erase(item)
		emit_signal("equipment_changed")
		emit_signal("inventory_changed")

func unequip_item(slot_type: String):
	if slot_type in equipped_items and equipped_items[slot_type]:
		var item = equipped_items[slot_type]
		equipped_items[slot_type] = null
		inventory_items.append(item)
		emit_signal("equipment_changed")
		emit_signal("inventory_changed")
		return item
	return null

func add_to_inventory(item):
	inventory_items.append(item)
	emit_signal("inventory_changed")

func remove_from_inventory(item):
	inventory_items.erase(item)
	emit_signal("inventory_changed")

func get_equipped_item(slot_type: String):
	return equipped_items.get(slot_type)

func get_inventory_items():
	return inventory_items
