extends Node

signal data_loaded
signal data_saved
signal sync_completed

const SAVE_FILE_PATH = "user://game_data.save"
const CLOUD_SAVE_NAME = "cloud_save"

var user_data = {
	"user_id": "",
	"inventory": [],
	"equipped_items": {},
	"score": 0,
	"deaths": 0
}

var is_logged_in = false

func _ready():
	SignInClient.connect("sign_in_success", _on_sign_in_success)
	SignInClient.connect("sign_in_failed", _on_sign_in_failed)
	SignInClient.connect("sign_out_success", _on_sign_out_success)
	SignInClient.connect("sign_out_failed", _on_sign_out_failed)
	SnapshotsClient.connect("save_snapshot_success", _on_save_snapshot_success)
	SnapshotsClient.connect("save_snapshot_failed", _on_save_snapshot_failed)
	SnapshotsClient.connect("load_snapshot_success", _on_load_snapshot_success)
	SnapshotsClient.connect("load_snapshot_failed", _on_load_snapshot_failed)
	
	load_local_data()

func save_local_data():
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if file:
		file.store_var(user_data)
		file.close()
		emit_signal("data_saved")
	else:
		print("Error: No se pudo abrir el archivo para guardar")

func load_local_data():
	if FileAccess.file_exists(SAVE_FILE_PATH):
		var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
		if file:
			user_data = file.get_var()
			file.close()
			emit_signal("data_loaded")
		else:
			print("Error: No se pudo abrir el archivo para cargar")
	else:
		print("No se encontró archivo de guardado local")

func login_user():
	SignInClient.sign_in()

func logout_user():
	SignInClient.sign_out()

func _on_sign_in_success():
	is_logged_in = true
	SnapshotsClient.load_snapshot(CLOUD_SAVE_NAME)

func _on_sign_in_failed(error_code: int):
	print("Error al iniciar sesión: ", error_code)
	is_logged_in = false

func _on_sign_out_success():
	is_logged_in = false
	user_data["user_id"] = ""
	save_local_data()

func _on_sign_out_failed(error_code: int):
	print("Error al cerrar sesión: ", error_code)

func _on_save_snapshot_success():
	print("Datos guardados en la nube exitosamente")
	emit_signal("sync_completed")

func _on_save_snapshot_failed(error_code: int):
	print("Error al guardar datos en la nube: ", error_code)

func _on_load_snapshot_success(data: String):
	var json = JSON.new()
	var parse_result = json.parse(data)
	if parse_result == OK:
		user_data = json.get_data()
		save_local_data()
		emit_signal("data_loaded")
	else:
		print("Error al parsear los datos cargados de la nube")

func _on_load_snapshot_failed(error_code: int):
	print("Error al cargar datos de la nube: ", error_code)
	load_local_data()

func update_data(key, value):
	user_data[key] = value
	save_local_data()
	if is_logged_in:
		var json_string = JSON.stringify(user_data)
		SnapshotsClient.save_snapshot(CLOUD_SAVE_NAME, json_string, "Autosave")

func update_inventory(inventory):
	update_data("inventory", inventory)

func update_equipped_items(equipped_items):
	update_data("equipped_items", equipped_items)

func update_score(score):
	update_data("score", score)

func update_deaths(deaths):
	update_data("deaths", deaths)
