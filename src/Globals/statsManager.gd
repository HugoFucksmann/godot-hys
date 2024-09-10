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
	stats_updated.emit(total_stats)

func update_total_stats():
	reset_total_stats()
	if GlobalState.current_character and GlobalState.current_character is Object:
		add_stats(GlobalState.current_character.stats)
	
	for slot in GlobalState.equipped_items:
		var item = GlobalState.equipped_items[slot]
		if item and item is Object:
			if "get_stats" in item:
				add_stats(item.get_stats())
			elif "stats" in item:
				add_stats(item.stats)
	
	current_health = min(current_health, total_stats["max_health"])
	stats_updated.emit(total_stats)

func get_stat(stat_name: String) -> float:
	return total_stats.get(stat_name, 0.0)

func add_stats(stats: Dictionary):
	if stats:
		for stat in stats:
			if stat in total_stats:
				total_stats[stat] += stats[stat]

func calculate_damage(damage_type: String) -> float:
	var base_damage = get_stat("damage")
	var type_damage = get_stat(damage_type + "_damage")
	var final_damage = base_damage * (type_damage / 100.0)
	
	if randf() * 100 <= get_stat("crit_chance"):
		final_damage *= get_stat("crit_damage")
	
	return final_damage

func take_damage(amount: float) -> float:
	if randf() * 100 <= get_stat("dodge_chance"):
		return 0.0
	
	var damage_reduction = get_stat("defense") / 100.0
	var actual_damage = amount * (1 - damage_reduction)
	
	current_health = max(current_health - actual_damage, 0)
	
	return actual_damage

func heal(amount: float):
	current_health = min(current_health + amount, get_stat("max_health"))

func is_alive() -> bool:
	return current_health > 0

static func is_available() -> bool:
	return Engine.has_singleton("StatsManager")
