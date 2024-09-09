extends BaseEquippableItem
class_name WeaponItem

signal weapon_fired(bullet_scene, position, direction)

var bullet_scene: PackedScene
var sprite: Sprite2D
var shoot_timer: Timer

func _ready():
	shoot_timer = Timer.new()
	shoot_timer.one_shot = true
	add_child(shoot_timer)
	shoot_timer.connect("timeout", Callable(self, "_on_shoot_timer_timeout"))

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
	if bullet_scene and shoot_timer.is_stopped():
		emit_signal("weapon_fired", bullet_scene, from_position, direction)
		start_shoot_cooldown()

func start_shoot_cooldown():
	var attack_speed = StatsManager.get_stat("attack_speed")
	shoot_timer.start(1.0 / attack_speed)

func _on_shoot_timer_timeout():
	print("Weapon ready to shoot again")
