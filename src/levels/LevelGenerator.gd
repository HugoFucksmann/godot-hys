extends Node

class_name LevelGenerator

signal level_generated(level_config: Dictionary)

const BASE_ENEMY_COUNT = 5
const BASE_RESOURCE_COUNT = 10
const ENEMY_INCREMENT_RATE = 0.1  # 10% increase per level
const RESOURCE_DECREMENT_RATE = 0.05  # 5% decrease per level

var current_level: int = 0
var player_performance: float = 1.0  # 1.0 is baseline, higher values mean better performance

var enemy_types = {
	"basic_enemy": {"min_level": 1, "base_frequency": 0.7},
	"fast_enemy": {"min_level": 3, "base_frequency": 0.3},
	"tough_enemy": {"min_level": 5, "base_frequency": 0.2},
	"boss_enemy": {"min_level": 10, "base_frequency": 0.05}
}

func generate_next_level() -> Dictionary:
	current_level += 1
	var level_config = {
		"level": current_level,
		"enemy_count": calculate_enemy_count(),
		"resource_count": calculate_resource_count(),
		"enemies": select_enemies(),
		"difficulty_multiplier": calculate_difficulty_multiplier()
	}
	emit_signal("level_generated", level_config)
	return level_config

func calculate_enemy_count() -> int:
	return int(BASE_ENEMY_COUNT * (1 + ENEMY_INCREMENT_RATE * (current_level - 1)) * player_performance)

func calculate_resource_count() -> int:
	return max(1, int(BASE_RESOURCE_COUNT * (1 - RESOURCE_DECREMENT_RATE * (current_level - 1)) / player_performance))

func select_enemies() -> Dictionary:
	var enemies = {}
	var total_frequency = 0.0
	
	for enemy_type in enemy_types:
		if current_level >= enemy_types[enemy_type]["min_level"]:
			var adjusted_frequency = enemy_types[enemy_type]["base_frequency"] * (current_level - enemy_types[enemy_type]["min_level"] + 1)
			enemies[enemy_type] = adjusted_frequency
			total_frequency += adjusted_frequency
	
	# Normalize frequencies
	for enemy_type in enemies:
		enemies[enemy_type] /= total_frequency
	
	return enemies

func calculate_difficulty_multiplier() -> float:
	return 1 + (current_level - 1) * 0.05 * player_performance

func update_player_performance(score: int, time_taken: float):
	var expected_score = BASE_ENEMY_COUNT * current_level * 10  # Assuming 10 points per enemy
	var performance = score / expected_score
	var time_factor = 120 / max(time_taken, 60)  # Assuming 2 minutes is par time
	player_performance = (performance + time_factor) / 2
	player_performance = clamp(player_performance, 0.5, 2.0)  # Limit performance factor

func reset():
	current_level = 0
	player_performance = 1.0
