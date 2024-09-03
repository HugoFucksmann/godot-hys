extends Node

signal stats_updated(new_stats: Dictionary)

var total_stats = {}

func _ready():
	reset_total_stats()

func reset_total_stats():
	total_stats = {
		"health": 100,
		"max_health": 100,
		"damage": 11,
		"speed": 600,
		"attack_speed": 1.0,
		"crit_damage": 2.0,
		"crit_chance": 10.0,
		"defense": 5,
		"pickup_radius": 50,
		"distance_damage": 100.0,
		"melee_damage": 0.0,
		"magic_damage": 0.0,
		"area_damage_radius": 0.0
	}
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
	
	emit_signal("stats_updated", total_stats)

func get_stat(stat_name: String) -> float:
	return total_stats.get(stat_name, 0.0)

func add_stats(stats: Dictionary):
	if stats == null:
		return
	for stat in stats:
		if stat in total_stats:
			total_stats[stat] += stats[stat]

static func is_available() -> bool:
	return Engine.has_singleton("StatsManager")
