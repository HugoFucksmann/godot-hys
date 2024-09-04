extends Control

func _ready():
	ensure_game_state()
	if not DataManager.user_data["user_id"]:
		DataManager.load_local_data()
	update_ui()
	
func ensure_game_state():
	get_tree().paused = false

func update_ui():
	# Actualiza la UI con los datos del usuario
	# Por ejemplo:
	#$ScoreLabel.text = "Score: " + str(DataManager.user_data["score"])
	#$DeathsLabel.text = "Deaths: " + str(DataManager.user_data["deaths"])
	pass
func _on_score_changed(new_score):
	DataManager.update_score(new_score)
	update_ui()

func _on_death_occurred():
	DataManager.update_deaths(DataManager.user_data["deaths"] + 1)
	update_ui()

func _on_quit_pressed():
	# Asegúrate de que los datos se guarden antes de salir
	DataManager.save_local_data()
	get_tree().quit()
