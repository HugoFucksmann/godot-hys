extends Button

@export_file("*.tscn") var next_scene_path: String

func _ready():
	pressed.connect(_on_button_up)

func _on_button_up():
	get_tree().paused = false  # Reanuda el juego
	if next_scene_path:
		get_tree().change_scene_to_file("res://src/MainScreens/survivor_game.tscn")
	else:
		print("Error: Next scene path not set!")
