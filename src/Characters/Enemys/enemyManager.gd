extends Node
class_name EnemyManager

var enemy_data: Dictionary
var global_enemy_scene: PackedScene
var player_ref: CharacterBody2D

func _init(player: CharacterBody2D):
	print("EnemyManager initialized")
	player_ref = player
	load_enemies_from_file("res://src/Characters/Enemys/enemies_data.json")
	global_enemy_scene = load("res://src/Enemys/BaseEnemy.tscn")
	if not global_enemy_scene:
		print("Error: Failed to load global enemy scene")

func load_enemies_from_file(file_path: String):
	print("Attempting to load enemy data from: ", file_path)
	
	if not FileAccess.file_exists(file_path):
		print("Error: File does not exist: ", file_path)
		return
	
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var json_text = file.get_as_text()
		file.close()
		
		print("JSON content:", json_text)
		
		var json = JSON.new()
		var parse_result = json.parse(json_text)
		
		if parse_result == OK:
			enemy_data = json.data
			print("Parsed enemy data:", enemy_data)
			for enemy_name in enemy_data.keys():
				print("Enemy loaded: ", enemy_name)
		else:
			print("JSON Parse Error: ", json.get_error_message(), " at line ", json.get_error_line())
	else:
		print("Failed to open file: ", file_path)

func create_enemy(enemy_name: String) -> BaseEnemy:
	print("Attempting to create enemy: ", enemy_name)
	print("Available enemy types: ", enemy_data.keys())
	
	if enemy_name in enemy_data:
		var data = enemy_data[enemy_name]
		print("Enemy data found: ", data)
		
		if global_enemy_scene:
			var enemy_instance: BaseEnemy = global_enemy_scene.instantiate()
			
			enemy_instance.initialize(player_ref)
			enemy_instance.set_stats(data["stats"])
			enemy_instance.score = data["score"]
			enemy_instance.set_animations(data["hurt_animation"], data["death_animation"])
			enemy_instance.set_texture(data["sprite_texture"])
			
			print("Enemy instance created successfully")
			return enemy_instance
		else:
			print("Failed to instantiate global enemy scene")
			return null
	else:
		print("Error: Enemy '", enemy_name, "' not found in data.")
		return null
