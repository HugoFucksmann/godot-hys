extends Node

signal score_updated(new_score: int)
signal deaths_updated(new_deaths: int)

var score: int = 0:
	set(value):
		score = value
		emit_signal("score_updated", score)
		SaveManager.set_save_data("score", score)

var deaths: int = 0:
	set(value):
		deaths = value
		emit_signal("deaths_updated", deaths)
		SaveManager.set_save_data("deaths", deaths)

var current_character = null
var equipped_items: Dictionary = {
	"arma": null,
	"guantes": null,
	"botas": null,
	"armadura": null,
	"casco": null,
	"accesorio": null
}

func _ready():
	SaveManager.connect("data_loaded", Callable(self, "_on_data_loaded"))
	SaveManager.load_game()

func set_current_character(character):
	current_character = character
	StatsManager.update_total_stats()

func update_equipped_items():
	StatsManager.update_total_stats()
	var equipped_items_data = {}
	for slot in equipped_items:
		if equipped_items[slot]:
			equipped_items_data[slot] = equipped_items[slot].to_dict()
	SaveManager.set_save_data("equipped_items", equipped_items_data)

func _on_data_loaded():
	var save_data = SaveManager.get_save_data()
	score = save_data["score"]
	deaths = save_data["deaths"]
	
	for slot in save_data["equipped_items"]:
		var item_data = save_data["equipped_items"][slot]
		if item_data:
			var loaded_item = ItemManager.create_item_from_data(item_data)
			if loaded_item:
				if slot == "arma":
					var bullet_scene_path = loaded_item.get_stat("bullet_scene")
					if bullet_scene_path and bullet_scene_path is String:
						loaded_item.stats["bullet_scene"] = load(bullet_scene_path)
				equipped_items[slot] = loaded_item
	
	StatsManager.update_total_stats()
