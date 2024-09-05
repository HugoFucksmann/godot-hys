extends Node

signal stats_updated(new_stats: Dictionary)

var total_stats = {}
var current_health: float

func _ready():
	reset_total_stats()

func reset_total_stats():
	total_stats = {
		"health": 100,
		"max_health": 100,
		"damage": 10,
		"speed": 600,
		"attack_speed": 1.0,
		"crit_damage": 2.0,
		"crit_chance": 10.0,
		"defense": 5,
		"dodge_chance": 5.0,
		"pickup_radius": 50,
		"distance_damage": 100.0,
		"melee_damage": 100.0,
		"magic_damage": 100.0,
		"area_damage_radius": 0.0
	}
	current_health = total_stats["max_health"]
	emit_signal("stats_updated", total_stats)

func update_total_stats():
	reset_total_stats()
	if GlobalState.current_character:
		if typeof(GlobalState.current_character) == TYPE_OBJECT:
			add_stats(GlobalState.current_character.stats)
		else:
			print("Warning: current_character is not a valid object")
	
	for slot in GlobalState.equipped_items:
		var item = GlobalState.equipped_items[slot]
		if item:
			if typeof(item) == TYPE_OBJECT:
				if item.has_method("get_stats"):
					add_stats(item.get_stats())
				elif "stats" in item:
					add_stats(item.stats)
				else:
					print("Warning: Item in slot ", slot, " doesn't have stats")
			else:
				print("Warning: Item in slot ", slot, " is not a valid object")
	
	current_health = min(current_health, total_stats["max_health"])
	emit_signal("stats_updated", total_stats)

func get_stat(stat_name: String) -> float:
	return total_stats.get(stat_name, 0.0)

func add_stats(stats: Dictionary):
	if stats == null:
		return
	for stat in stats:
		if stat in total_stats:
			total_stats[stat] += stats[stat]

func calculate_damage(damage_type: String) -> float:
	var base_damage = get_stat("damage")
	var type_damage = get_stat(damage_type + "_damage")
	var final_damage = base_damage * (type_damage / 100.0)
	
	# Aplicar crítico
	if randf() * 100 <= get_stat("crit_chance"):
		final_damage *= get_stat("crit_damage")
	
	return final_damage

func take_damage(amount: float) -> float:
	# Aplicar defensa y probabilidad de esquivar
	if randf() * 100 <= get_stat("dodge_chance"):
		return 0.0  # Daño esquivado
	
	var damage_reduction = get_stat("defense") / 100.0
	var actual_damage = amount * (1 - damage_reduction)
	
	current_health -= actual_damage
	current_health = max(current_health, 0)
	
	return actual_damage

func heal(amount: float):
	current_health += amount
	current_health = min(current_health, get_stat("max_health"))

func is_alive() -> bool:
	return current_health > 0

static func is_available() -> bool:
	return Engine.has_singleton("StatsManager")
