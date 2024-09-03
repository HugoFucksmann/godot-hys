extends Node

signal score_updated(new_score: int)
signal deaths_updated(new_deaths: int)

var score: int = 0:
	set(value):
		score = value
		emit_signal("score_updated", score)
		DataManager.update_score(score)

var deaths: int = 0:
	set(value):
		deaths = value
		emit_signal("deaths_updated", deaths)
		DataManager.update_deaths(deaths)

var current_character = null

# Ahora solo mantenemos referencias a los items equipados
var equipped_items: Dictionary = {
	"arma": null,
	"guantes": null,
	"botas": null,
	"armadura": null,
	"casco": null,
	"accesorio": null
}

func _ready():
	DataManager.connect("data_loaded", Callable(self, "on_data_loaded"))

func set_current_character(character):
	current_character = character
	StatsManager.update_total_stats()

func on_data_loaded():
	score = DataManager.user_data.get("score", 0)
	deaths = DataManager.user_data.get("deaths", 0)
	
	var loaded_equipped_items = DataManager.user_data.get("equipped_items", {})
	for slot in equipped_items.keys():
		equipped_items[slot] = loaded_equipped_items.get(slot, null)
	
	StatsManager.update_total_stats()

func update_equipped_items():
	DataManager.update_equipped_items(equipped_items)
	StatsManager.update_total_stats()
