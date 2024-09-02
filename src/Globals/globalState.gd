extends Node

signal inventory_updated
signal stats_updated

@export var score: int
@export var deaths: int

var player_inventory = []  # Almacena todos los ítems sin límite
var total_stats = {}

var current_character = null
var equipped_items = {
	"arma": null,
	"guantes": null,
	"botas": null,
	"armadura": null,
	"casco": null,
	"accesorio": null
}

func _ready():
	add_initial_items()
	reset_total_stats()

func add_initial_items():
	var initial_gun = load("res://src/Items/Weapons/gun/area_gun.tscn").instantiate()
	var initial_armor = load("res://src/Items/Armors/redDragon/redDragon.tscn").instantiate()
	add_item_to_inventory(initial_gun)
	add_item_to_inventory(initial_gun.duplicate())
	add_item_to_inventory(initial_armor)

func reset_total_stats():
	total_stats = {
		"health": 100,
		"max_health": 100,
		"damage": 11,
		"speed": 600,
		"attack_speed": 1.0,
		"crit_damage": 0.0,
		"crit_chance": 0.0,
		"defense": 5,
		"pickup_radius": 50,
		"distance_damage": 100.0,
		"melee_damage": 0.0,
		"magic_damage": 0.0,
		"area_damage_radius": 0.0
	}

func update_total_stats():
	reset_total_stats()

	if current_character:
		add_stats(current_character.stats)

	for item in equipped_items.values():
		if item:
			add_stats(item.stats)

	emit_signal("stats_updated", total_stats)

func set_current_character(character):
	current_character = character
	update_total_stats()

func equip_item(item, slot):
	if slot in equipped_items:
		if equipped_items[slot]:
			unequip_item(slot)
		equipped_items[slot] = item
		update_total_stats()
		return true
	return false

func get_stat(stat_name: String) -> float:
	return total_stats.get(stat_name, 0.0)

func unequip_item(slot):
	if slot in equipped_items and equipped_items[slot]:
		var item = equipped_items[slot]
		equipped_items[slot] = null
		update_total_stats()
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

func add_stats(stats: Dictionary):
	for stat in stats:
		if stat in total_stats:
			total_stats[stat] += stats[stat]
	emit_signal("stats_updated", total_stats)
