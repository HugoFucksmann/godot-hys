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
		weapon_fired.emit(bullet_scene, from_position, direction)
		start_shoot_cooldown()

func start_shoot_cooldown():
	var attack_speed = StatsManager.get_stat("attack_speed")
	shoot_timer.start(1.0 / attack_speed)

func _on_shoot_timer_timeout():
	pass
