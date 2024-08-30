extends Node

signal inventory_updated

var player_inventory = []
var max_inventory_slots = 20

func _ready():
	# Añadir el arma inicial al inventario del jugador
	var initial_gun = load("res://src/Items/Weapons/gun/area_gun.tscn").instantiate()
	add_item_to_inventory(initial_gun)

func add_item_to_inventory(item: GlobalItem):
	if player_inventory.size() < max_inventory_slots:
		player_inventory.append(item)
		emit_signal("inventory_updated")
		return true
	return false

func remove_item_from_inventory(item: GlobalItem):
	if player_inventory.has(item):
		player_inventory.erase(item)
		emit_signal("inventory_updated")
		return true
	return false

func get_inventory():
	return player_inventory
