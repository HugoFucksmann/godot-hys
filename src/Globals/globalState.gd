extends Node

signal score_updated(new_score: int)
signal deaths_updated(new_deaths: int)
signal equipped_items_updated

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
var equipped_items: Dictionary = {
	"arma": null, "guantes": null, "botas": null,
	"armadura": null, "casco": null, "accesorio": null
}:
	set(value):
		equipped_items = value
		update_equipped_items()

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
		var item_data = loaded_equipped_items.get(slot)
		if item_data:
			var item = create_item_from_data(item_data)
			equipped_items[slot] = item
		else:
			equipped_items[slot] = null

	emit_signal("equipped_items_updated")
	StatsManager.update_total_stats()

func update_equipped_items():
	var equipped_items_data = {}
	for slot in equipped_items:
		var item = equipped_items[slot]
		if item and item is GlobalItem:
			equipped_items_data[slot] = item.get_save_data()
		else:
			equipped_items_data[slot] = null
	
	DataManager.update_equipped_items(equipped_items_data)
	emit_signal("equipped_items_updated")
	StatsManager.update_total_stats()

func create_item_from_data(item_data) -> GlobalItem:
	var item = GlobalItem.new()
	if item_data is Dictionary:
		item.load_save_data(item_data)
	elif item_data is GlobalItem:
		item = item_data
	else:
		push_error("Invalid item data type")
	return item
