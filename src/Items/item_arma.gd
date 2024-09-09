extends BaseEquippableItem
class_name WeaponItem

signal weapon_fired(bullet_scene, position, direction)

var bullet_scene: PackedScene
var shoot_timer: Timer

func _ready():
	shoot_timer = Timer.new()
	shoot_timer.one_shot = true
	add_child(shoot_timer)
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)

func apply_item_properties():
	super.apply_item_properties()
	bullet_scene = item_data.get_stat("bullet_scene")

func shoot(from_position: Vector2, direction: Vector2):
	if bullet_scene and shoot_timer.is_stopped():
		if item_data.name == "Shotgun":
			_shoot_shotgun(from_position, direction)
		else:
			_shoot_single_bullet(from_position, direction)
		start_shoot_cooldown()

func _shoot_single_bullet(from_position: Vector2, direction: Vector2):
	weapon_fired.emit(bullet_scene, from_position, direction)

func _shoot_shotgun(from_position: Vector2, direction: Vector2):
	const BULLET_COUNT = 5
	const BULLET_SPREAD = 15  # ángulo máximo de dispersión en grados
	
	var base_rotation = direction.angle()
	for i in range(BULLET_COUNT):
		var bullet_rotation = base_rotation + deg_to_rad(randf_range(-BULLET_SPREAD, BULLET_SPREAD))
		var bullet_direction = Vector2.RIGHT.rotated(bullet_rotation)
		weapon_fired.emit(bullet_scene, from_position, bullet_direction)

func start_shoot_cooldown():
	var attack_speed = StatsManager.get_stat("attack_speed")
	shoot_timer.start(1.0 / attack_speed)

func _on_shoot_timer_timeout():
	pass
