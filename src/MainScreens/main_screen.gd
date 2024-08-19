extends Control

func _ready():
	ensure_game_state()

func ensure_game_state():
	get_tree().paused = false
