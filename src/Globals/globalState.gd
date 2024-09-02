extends Node

signal inventory_updated
signal stats_updated

@export var score: int
@export var deaths: int
var player_inventory = []
var max_inventory_slots = 20

var total_stats = {
	"health": 100,
	"max_health": 100,
	"damage": 10,
	"speed": 600,
	"attack_speed": 1.0,
	"crit_damage": 0.0,
	"crit_chance": 0.0,
	"defense": 5,
	"pickup_radius": 50,
	"distance_damage": 0.0,
	"melee_damage": 0.0,
	"magic_damage": 0.0,
	"area_damage_radius": 0.0
}

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

func add_initial_items():
	var initial_gun = load("res://src/Items/Weapons/gun/area_gun.tscn").instantiate()
	var initial_armor = load("res://src/Items/Armors/redDragon/redDragon.tscn").instantiate()
	add_item_to_inventory(initial_gun)
	add_item_to_inventory(initial_gun.duplicate())
	add_item_to_inventory(initial_armor)

func update_total_stats():
	# Reset stats to base values
	total_stats = {
		"health": 100,
		"max_health": 100,
		"damage": 10,
		"speed": 600,
		"attack_speed": 1.0,
		"crit_damage": 0.0,
		"crit_chance": 0.0,
		"defense": 5,
		"pickup_radius": 50,
		"distance_damage": 0.0,
		"melee_damage": 0.0,
		"magic_damage": 0.0,
		"area_damage_radius": 0.0
	}
	
	if current_character:
		for stat in current_character.stats:
			if stat in total_stats:
				total_stats[stat] += current_character.stats[stat]
	
	for item in equipped_items.values():
		if item:
			for stat in item.stats:
				if stat in total_stats:
					total_stats[stat] += item.stats[stat]
	
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

func unequip_item(slot):
	if slot in equipped_items and equipped_items[slot]:
		var item = equipped_items[slot]
		equipped_items[slot] = null
		update_total_stats()
		return item
	return null

func get_stat(stat_name: String) -> float:
	return total_stats.get(stat_name, 0.0)

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
		# Aquí puedes agregar lógica adicional si el inventario está lleno
