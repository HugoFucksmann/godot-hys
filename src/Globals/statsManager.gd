extends Node

signal stats_updated

var total_stats = {}

func _ready():
	print("StatsManager initialized")  # Debug print
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

func update_total_stats(all_stats: Array):
	reset_total_stats()
	for stats in all_stats:
		add_stats(stats)

func get_stat(stat_name: String) -> float:
	return total_stats.get(stat_name, 0.0)

func add_stats(stats: Dictionary):
	if stats == null:
		print("Warning: Attempted to add null stats")
		return
	for stat in stats:
		if stat in total_stats:
			total_stats[stat] += stats[stat]
	emit_signal("stats_updated", total_stats)

# Static function to check if StatsManager is available
static func is_available() -> bool:
	return Engine.has_singleton("StatsManager")
