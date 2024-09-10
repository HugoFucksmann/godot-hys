extends Node

signal signed_in
signal signed_out
signal save_success
signal save_failed
signal load_success
signal load_failed

var gpgs_instance

func _ready():
	if Engine.has_singleton("GodotGooglePlayGameServices"):
		gpgs_instance = Engine.get_singleton("GodotGooglePlayGameServices")
		setup_gpgs()
	else:
		print("GPGS not available on this platform")

func setup_gpgs():
	gpgs_instance.init()
	gpgs_instance.connect("sign_in_success", Callable(self, "_on_gpgs_connected"))
	gpgs_instance.connect("sign_in_failed", Callable(self, "_on_gpgs_disconnected"))
	gpgs_instance.connect("save_success", Callable(self, "_on_save_game"))
	gpgs_instance.connect("load_success", Callable(self, "_on_load_game"))
	gpgs_instance.connect("load_failed", Callable(self, "_on_load_game_failed"))
	
	# Intenta iniciar sesión automáticamente
	sign_in()

func sign_in():
	if gpgs_instance:
		gpgs_instance.sign_in()

func sign_out():
	if gpgs_instance:
		gpgs_instance.sign_out()

func save_game(save_name: String, data: Dictionary):
	if gpgs_instance:
		var save_data = JSON.stringify(data)
		gpgs_instance.save_snapshot(save_name, save_data, "Autosave")

func load_game(save_name: String):
	if gpgs_instance:
		gpgs_instance.load_snapshot(save_name)

func _on_gpgs_connected():
	print("Successfully connected to GPGS")
	emit_signal("signed_in")

func _on_gpgs_disconnected():
	print("Disconnected from GPGS")
	emit_signal("signed_out")

func _on_save_game(success: bool):
	if success:
		print("Game saved successfully")
		emit_signal("save_success")
	else:
		print("Failed to save game")
		emit_signal("save_failed")

func _on_load_game(data: String):
	print("Game loaded successfully")
	var json = JSON.new()
	var parse_result = json.parse(data)
	if parse_result == OK:
		var loaded_data = json.get_data()
		emit_signal("load_success", loaded_data)
	else:
		print("Failed to parse loaded data")
		emit_signal("load_failed")

func _on_load_game_failed():
	print("Failed to load game")
	emit_signal("load_failed")

# Funciones adicionales para logros y tablas de clasificación

func unlock_achievement(achievement_id: String):
	if gpgs_instance:
		gpgs_instance.unlock_achievement(achievement_id)

func increment_achievement(achievement_id: String, steps: int):
	if gpgs_instance:
		gpgs_instance.increment_achievement(achievement_id, steps)

func show_achievements():
	if gpgs_instance:
		gpgs_instance.show_achievements()

func submit_leaderboard_score(leaderboard_id: String, score: int):
	if gpgs_instance:
		gpgs_instance.submit_leaderboard_score(leaderboard_id, score)

func show_leaderboard(leaderboard_id: String):
	if gpgs_instance:
		gpgs_instance.show_leaderboard(leaderboard_id)
