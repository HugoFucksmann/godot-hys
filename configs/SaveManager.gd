extends Node

const SAVE_PATH = "user://savegame.save"

signal data_loaded
signal data_saved

var save_data = {
	"score": 0,
	"deaths": 0,
	"equipped_items": {},
	"last_save_time": 0
}

func _ready():
	load_game()

func save_game():
	save_data["last_save_time"] = Time.get_unix_time_from_system()
	
	var save_game = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var json_string = JSON.stringify(save_data)
	save_game.store_line(json_string)
	emit_signal("data_saved")

func load_game():
	if not FileAccess.file_exists(SAVE_PATH):
		return
	
	var save_game = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var json_string = save_game.get_line()
	
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	
	if parse_result != OK:
		print("Error parsing save data")
		return
	
	var loaded_data = json.get_data()
	
	# Comprueba si los datos cargados son más recientes
	if loaded_data.get("last_save_time", 0) > save_data["last_save_time"]:
		save_data = loaded_data
	
	emit_signal("data_loaded")

func get_save_data():
	return save_data

func set_save_data(key, value):
	save_data[key] = value
	save_game()

func sync_with_gpgs():
	if Engine.has_singleton("GodotGooglePlayGamesServices"):
		GPGSManager.save_game("AutoSave", save_data)
	else:
		print("GPGS not available, data saved locally")

func load_from_gpgs(gpgs_data):
	if gpgs_data.get("last_save_time", 0) > save_data["last_save_time"]:
		save_data = gpgs_data
		save_game()
	emit_signal("data_loaded")
