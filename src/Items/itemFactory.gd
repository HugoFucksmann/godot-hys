extends Node

static func create_item(item_data: Dictionary) -> GlobalItem:
	var item = GlobalItem.new(
		item_data.get("name", ""),
		load(item_data.get("icon_path", "")),
		item_data.get("item_type", GlobalItem.ItemType.ARMA),
		load(item_data.get("bullet_scene_path", "")) if item_data.get("bullet_scene_path") else null,
		item_data.get("stats", {})
	)
	return item

# Ejemplo de uso
