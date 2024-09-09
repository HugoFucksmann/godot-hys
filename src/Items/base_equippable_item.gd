extends Node2D
class_name BaseEquippableItem

var item_data: BaseItem

func initialize(data: BaseItem):
	item_data = data
	apply_item_properties()
	apply_stats()

func apply_item_properties():
	if item_data and item_data.icon:
		var sprite = Sprite2D.new()
		sprite.texture = item_data.icon
		add_child(sprite)

func apply_stats():
	pass

func get_stats() -> Dictionary:
	return item_data.stats if item_data else {}
