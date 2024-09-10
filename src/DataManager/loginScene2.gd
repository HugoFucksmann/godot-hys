extends Control

@onready var login_button = $LoginButton
@onready var guest_button = $GuestButton

func _ready():
	login_button.connect("pressed", _on_login_pressed)
	guest_button.connect("pressed", _on_guest_pressed)
	
	DataManager.connect("data_loaded", _on_data_loaded)

func _on_login_pressed():
	DataManager.login_user()

func _on_guest_pressed():
	# Cargar datos locales y comenzar el juego sin login
	get_tree().change_scene_to_file("res://main_game.tscn")

func _on_data_loaded():
	# Los datos se han cargado (ya sea de la nube o localmente)
	get_tree().change_scene_to_file("res://main_game.tscn")
