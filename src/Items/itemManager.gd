extends Node

var item_scenes: Dictionary

func _ready():
	load_items_from_file("res://src/Items/items_data.json")

func load_items_from_file(file_path: String):
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var json_text = file.get_as_text()
		file.close()
		
		var json = JSON.new()
		var parse_result = json.parse_string(json_text)
		
		var items_data = parse_result
		item_scenes = items_data
		for item_category in items_data.keys():
			var items_array = items_data[item_category]
			for item_data in items_array:
				var item = create_item_from_data(item_data)
				if item:
					print("Item creado: ", item.name)

func create_item_from_data(item_data: Dictionary) -> BaseItem:
	if typeof(item_data) == TYPE_DICTIONARY:
		var item_name = item_data.get("name", "")
		var icon_path = item_data.get("icon", "")
		var icon: Texture = null
		if icon_path:
			icon = load(icon_path) as Texture
		var item_type = item_data.get("item_type", BaseItem.ItemType.ARMA)
		var bullet_scene_path = item_data.get("bullet_scene", "")
		var bullet_scene: PackedScene = null
		if bullet_scene_path:
			bullet_scene = load(bullet_scene_path) as PackedScene
		var stats = item_data.get("stats", {})

		var new_item = BaseItem.new(item_name, icon, item_type, bullet_scene)
		new_item.set_stats(stats)

		return new_item
	else:
		print("Error: item_data is not a Dictionary")
		return null

func create_item_by_name(item_name: String) -> BaseItem:
	var item_data = find_item_data_by_name(item_name)
	if item_data:
		return create_item_from_data(item_data)
	return null

func find_item_data_by_name(item_name: String) -> Dictionary:
	for category in item_scenes.keys():
		for item_data in item_scenes[category]:
			if item_data.get("name", "") == item_name:
				return item_data
	return {}
