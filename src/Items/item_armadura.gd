extends BaseEquippableItem
class_name ArmorItem

var sprite: Sprite2D

func ensure_sprite_exists():
	if not is_instance_valid(sprite):
		sprite = Sprite2D.new()
		add_child(sprite)
		print("Created new Sprite2D for ArmorItem")

func initialize(data: BaseItem):
	super.initialize(data)
	call_deferred("apply_item_properties")

func apply_item_properties():
	if not is_instance_valid(item_data):
		push_error("item_data is not valid in ArmorItem")
		return

	print("Applying item properties for: ", item_data.name)

	ensure_sprite_exists()

	if item_data.icon:
		if item_data.icon is Texture2D:
			sprite.texture = item_data.icon
			print("Texture applied successfully to ", item_data.name)
		else:
			push_error("Error: item_data.icon is not a Texture2D, it is: " + str(typeof(item_data.icon)))
	else:
		push_error("Error: item_data.icon is null or invalid for " + item_data.name)

func apply_stats():
	# Apply armor-specific stats here
	pass
