extends Control

func _ready():
	if Engine.has_singleton("GodotGooglePlayGamesServices"):
		GPGSManager.connect("signed_in", Callable(self, "_on_gpgs_signed_in"))
		GPGSManager.connect("load_success", Callable(self, "_on_game_loaded"))
	else:
		print("GPGS not available on this platform")
	ensure_game_state()
	update_ui()

func ensure_game_state():
	get_tree().paused = false

func update_ui():
	#$ScoreLabel.text = "Score: " + str(GlobalState.score)
	#$DeathsLabel.text = "Deaths: " + str(GlobalState.deaths)
	pass

func _on_score_changed(new_score):
	update_ui()

func _on_death_occurred():
	update_ui()

func _on_quit_pressed():
	SaveManager.save_game()
	get_tree().quit()

func _on_gpgs_signed_in():
	print("Usuario ha iniciado sesión en GPGS")
	GPGSManager.load_game("AutoSave")

func _on_game_loaded(data):
	print("Datos cargados de GPGS:", data)
	SaveManager.load_from_gpgs(data)
	update_ui()

func on_level_completed(level: int):
	const player_score = 100 # reemplazar valor por score real.
	GPGSManager.unlock_achievement("achievement_complete_level_" + str(level))
	GPGSManager.submit_leaderboard_score("leaderboard_high_scores", player_score)
	SaveManager.sync_with_gpgs()
