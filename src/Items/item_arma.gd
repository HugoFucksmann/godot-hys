extends BaseEquippableItem
class_name WeaponItem

var bullet_scene: PackedScene
var sprite: Sprite2D

func ensure_sprite_exists():
	if not is_instance_valid(sprite):
		sprite = Sprite2D.new()
		add_child(sprite)
		print("Created new Sprite2D for WeaponItem")

func initialize(data: BaseItem):
	super.initialize(data)
	call_deferred("apply_item_properties")

func apply_item_properties():
	if not is_instance_valid(item_data):
		push_error("item_data is not valid in WeaponItem")
		return

	print("Applying item properties for: ", item_data.name)

	bullet_scene = item_data.get_stat("bullet_scene")
	if not bullet_scene:
		push_warning("bullet_scene not found in item_data")

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
	# Apply weapon-specific stats here
	pass

func shoot(from_position: Vector2, direction: Vector2):
	if bullet_scene:
		var bullet = bullet_scene.instantiate()
		bullet.global_position = from_position
		bullet.rotation = direction.angle()
		bullet.damage = item_data.get_stat("damage", 1)
		get_tree().current_scene.add_child(bullet)
	else:
		push_warning("Attempted to shoot, but bullet_scene is not set")
