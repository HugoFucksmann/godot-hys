extends Node

signal item_added(item: Item)
signal item_removed(item: Item)

var items = []

func add_item(item: Item):
	items.append(item)
	emit_signal("item_added", item)

func remove_item(index: int) -> Item:
	if index >= 0 and index < items.size():
		var item = items[index]
		items.remove_at(index)
		emit_signal("item_removed", item)
		return item
	return null

func get_item(index: int) -> Item:
	if index >= 0 and index < items.size():
		return items[index]
	return null
