extends Node
class_name EnemyManager

var enemy_data: Dictionary
var global_enemy_scene: PackedScene
var player_ref: CharacterBody2D
var current_difficulty: int = 1

func _init(player: CharacterBody2D):
	player_ref = player
	load_enemies_from_file("res://src/Enemys/enemies_data.json")
	global_enemy_scene = load("res://src/Enemys/BaseEnemy.tscn")
	if not global_enemy_scene:
		print("Error: Failed to load BaseEnemy scene")

func load_enemies_from_file(file_path: String):
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		var json_text = file.get_as_text()
		file.close()
		
		var json = JSON.new()
		var parse_result = json.parse(json_text)
		
		if parse_result == OK:
			enemy_data = json.data
		else:
			print("JSON Parse Error: ", json.get_error_message(), " at line ", json.get_error_line())
	else:
		print("Failed to open file: ", file_path)

func set_difficulty(difficulty: int):
	current_difficulty = difficulty

func get_random_enemy_for_level(level: int) -> String:
	var available_enemies = []
	for enemy_name in enemy_data.keys():
		if enemy_data[enemy_name].get("min_level", 1) <= level:
			available_enemies.append(enemy_name)
	
	if available_enemies.is_empty():
		return "basic_enemy"  # Fallback to basic enemy if no enemies are available
	
	return available_enemies[randi() % available_enemies.size()]

func spawn_enemy(enemy_name: String, position: Vector2) -> BaseEnemy:
	if enemy_name in enemy_data:
		var data = enemy_data[enemy_name]
		
		if global_enemy_scene:
			var enemy_instance: BaseEnemy = global_enemy_scene.instantiate()
			
			enemy_instance.initialize(player_ref)
			var scaled_stats = scale_enemy_stats(data["stats"])
			enemy_instance.set_stats(scaled_stats)
			enemy_instance.score = data["score"]
			enemy_instance.set_animations(data["hurt_animation"], data["death_animation"])
			enemy_instance.set_texture(data["sprite_texture"])
			enemy_instance.global_position = position
			
			return enemy_instance
		else:
			print("Error: global_enemy_scene is null")
	else:
		print("Error: Enemy '", enemy_name, "' not found in data.")
	
	return null

func scale_enemy_stats(base_stats: Dictionary) -> Dictionary:
	var scaled_stats = base_stats.duplicate()
	var scale_factor = 1.0 + (current_difficulty - 1) * 0.1  # 10% increase per difficulty level
	
	for stat in scaled_stats.keys():
		if stat in ["health", "damage", "speed"]:
			scaled_stats[stat] = scaled_stats[stat] * scale_factor
	
	return scaled_stats
