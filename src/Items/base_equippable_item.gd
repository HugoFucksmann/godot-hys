extends Node2D
class_name BaseEquippableItem

var item_data: BaseItem

func initialize(data: BaseItem):
	item_data = data
	apply_item_properties()
	apply_stats()

func apply_item_properties():
	# Override this method in child classes to apply specific item properties
	pass

func apply_stats():
	# Override this method in child classes to apply specific stats
	pass

func get_stats() -> Dictionary:
	return item_data.stats if item_data else {}
