extends Node

signal score_updated(new_score: int)
signal deaths_updated(new_deaths: int)

var score: int = 0:
	set(value):
		score = value
		emit_signal("score_updated", score)
		save_game()

var deaths: int = 0:
	set(value):
		deaths = value
		emit_signal("deaths_updated", deaths)
		save_game()

var current_character = null

var equipped_items: Dictionary = {
	"arma": null,
	"guantes": null,
	"botas": null,
	"armadura": null,
	"casco": null,
	"accesorio": null
}

const SAVE_PATH = "user://savegame.save"

func _ready():
	load_game()
	

func set_current_character(character):
	current_character = character
	StatsManager.update_total_stats()

func update_equipped_items():
	StatsManager.update_total_stats()
	save_game()

func save_game():
	var save_dict = {
		"score": score,
		"deaths": deaths,
		"equipped_items": {}
	}
	
	for slot in equipped_items.keys():
		if equipped_items[slot]:
			save_dict["equipped_items"][slot] = equipped_items[slot].to_dict()
	
	var save_game = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var json_string = JSON.stringify(save_dict)
	save_game.store_line(json_string)

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
	
	var save_dict = json.get_data()
	
	score = save_dict["score"]
	deaths = save_dict["deaths"]
	
	for slot in save_dict["equipped_items"].keys():
		var item_data = save_dict["equipped_items"][slot]
		if item_data:
			var loaded_item = ItemManager.create_item_from_data(item_data)
			if loaded_item:
				# Para armas, cargamos la escena de la bala si existe
				if slot == "arma":
					var bullet_scene_path = loaded_item.get_stat("bullet_scene")
					if bullet_scene_path and typeof(bullet_scene_path) == TYPE_STRING:
						loaded_item.stats["bullet_scene"] = load(bullet_scene_path)
				equipped_items[slot] = loaded_item
	
	StatsManager.update_total_stats()

func debug_print_equipped_items():
	print("Currently equipped items:")
	for slot in equipped_items.keys():
		var item = equipped_items[slot]
		if item:
			print(slot + ": " + item.name)
		else:
			print(slot + ": None")
