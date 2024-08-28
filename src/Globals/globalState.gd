extends Node

var current_level: int = 1
var player_progress: float = 0.0
var selected_character: String = ""
var score: int = 0
var deaths: int = 0

func _ready():
	# Añadir el arma al inventario inicial del jugador
	var initial_gun = load("res://src/Items/Weapons/gun/gun.gd").new()
	add_item_to_inventory(initial_gun)



func save_game():
	# Implementa la lógica para guardar el juego
	pass

func load_game():
	# Implementa la lógica para cargar el juego
	pass

var player_inventory = []
var max_inventory_slots = 20

signal inventory_updated

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
