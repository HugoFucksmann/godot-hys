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
		_setup_gpgs()
	else:
		print("GPGS not available on this platform")

func _setup_gpgs():
	gpgs_instance.init()
	gpgs_instance.connect("onConnected", _on_gpgs_connected)
	gpgs_instance.connect("onDisconnected", _on_gpgs_disconnected)
	gpgs_instance.connect("onSavedGame", _on_save_game)
	gpgs_instance.connect("onLoadedGame", _on_load_game)

func sign_in():
	if gpgs_instance:
		gpgs_instance.signIn()

func sign_out():
	if gpgs_instance:
		gpgs_instance.signOut()

func save_game(save_name: String, data: Dictionary):
	if gpgs_instance:
		var save_data = JSON.stringify(data)
		gpgs_instance.savedGames_save(save_name, save_data)

func load_game(save_name: String):
	if gpgs_instance:
		gpgs_instance.savedGames_load(save_name)

func _on_gpgs_connected():
	emit_signal("signed_in")

func _on_gpgs_disconnected():
	emit_signal("signed_out")

func _on_save_game(success: bool):
	if success:
		emit_signal("save_success")
	else:
		emit_signal("save_failed")

func _on_load_game(success: bool, data: String):
	if success:
		var json = JSON.new()
		json.parse(data)
		var loaded_data = json.get_data()
		emit_signal("load_success", loaded_data)
	else:
		emit_signal("load_failed")
