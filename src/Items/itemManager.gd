extends Node

var item_scenes: Dictionary = {}

func _ready():
	load_items_from_file("res://src/Items/items_data.json")

func load_items_from_file(file_path: String):
	if not FileAccess.file_exists(file_path):
		print("Error: File does not exist: ", file_path)
		return

	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		print("Error: Could not open file: ", file_path)
		return

	var json_text = file.get_as_text()
	file.close()

	var json = JSON.new()
	var error = json.parse(json_text)
	if error != OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_text, " at line ", json.get_error_line())
		return

	var items_data = json.get_data()
	if typeof(items_data) != TYPE_DICTIONARY:
		print("Error: Parsed JSON is not a dictionary")
		return

	item_scenes = items_data
	
	for item_category in items_data.keys():
		var items_array = items_data[item_category]
		if typeof(items_array) != TYPE_ARRAY:
			print("Error: Category ", item_category, " is not an array")
			continue
		for item_data in items_array:
			var item = create_item_from_data(item_data)
			if item:
				print("Created item: ", item.name)

func create_item_from_data(item_data: Dictionary) -> BaseItem:
	if typeof(item_data) != TYPE_DICTIONARY:
		print("Error: item_data is not a Dictionary")
		return null

	var item_name = item_data.get("name", "")
	var icon_path = item_data.get("icon", "")
	var icon: Texture = null
	if icon_path:
		icon = load(icon_path) as Texture
	var item_type = item_data.get("item_type", BaseItem.ItemType.ARMA)
	var stats = item_data.get("stats", {})

	var new_item = BaseItem.new(item_name, icon, item_type)
	new_item.set_stats(stats)

	return new_item

func create_item_by_name(item_name: String) -> BaseItem:
	var item_data = find_item_data_by_name(item_name)
	if item_data:
		return create_item_from_data(item_data)
	return null

func find_item_data_by_name(item_name: String) -> Dictionary:
	for category in item_scenes.keys():
		var items_array = item_scenes[category]
		if typeof(items_array) != TYPE_ARRAY:
			continue
		for item_data in items_array:
			if typeof(item_data) != TYPE_DICTIONARY:
				continue
			if item_data.get("name", "") == item_name:
				return item_data
	return {}
