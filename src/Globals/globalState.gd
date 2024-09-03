extends Node

signal inventory_updated

@export var score: int
@export var deaths: int

var player_inventory = []  # Almacena todos los ítems sin límite
var current_character = null
var equipped_items = {
	"arma": null,
	"guantes": null,
	"botas": null,
	"armadura": null,
	"casco": null,
	"accesorio": null
}
var stats_manager: Node
func _ready():
	stats_manager = get_node("/root/StatsManager")

	add_initial_items()
	update_stats_manager()

func add_initial_items():
	var initial_gun = load("res://src/Items/Weapons/gun/area_gun.tscn").instantiate()
	var initial_armor = load("res://src/Items/Armors/redDragon/redDragon.tscn").instantiate()
	add_item_to_inventory(initial_gun)
	add_item_to_inventory(initial_gun.duplicate())
	add_item_to_inventory(initial_armor)

func set_current_character(character):
	current_character = character
	update_stats_manager()

func equip_item(item, slot):
	if slot in equipped_items:
		if equipped_items[slot]:
			unequip_item(slot)
		equipped_items[slot] = item
		update_stats_manager()
		return true
	return false

func unequip_item(slot):
	if slot in equipped_items and equipped_items[slot]:
		var item = equipped_items[slot]
		equipped_items[slot] = null
		update_stats_manager()
		return item
	return null

func add_item_to_inventory(item):
	player_inventory.append(item)
	emit_signal("inventory_updated")
	return true

func remove_item_from_inventory(item):
	var index = player_inventory.find(item)
	if index != -1:
		player_inventory.remove_at(index)
		emit_signal("inventory_updated")
		return true
	return false

func get_inventory():
	return player_inventory

func handle_unequipped_item(item):
	if not add_item_to_inventory(item):
		print("Failed to add unequipped item to inventory: ", item.name)

func update_stats_manager():
	if not stats_manager:
		push_error("StatsManager not available for update")
		return
	var all_stats = []
	if current_character:
		all_stats.append(current_character.stats)
	for item in equipped_items.values():
		if item:
			all_stats.append(item.stats)
	stats_manager.update_total_stats(all_stats)
