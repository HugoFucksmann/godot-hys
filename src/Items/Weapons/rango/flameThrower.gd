extends GlobalItem

var flame_area: Area2D

func _init():
	super._init(
		"Flamethrower",
		preload("res://src/Items/Weapons/gun/asset/pistol.png"),
		ItemType.ARMA
	)
	
	set_stats({
		"damage": 1,
		"attack_speed": 5.0,
		"distance_damage": 1,
		"pickup_radius": 50,
		"flame_range": 200
	})

func _ready():
	super._ready()
	setup_flame_area()

func setup_flame_area():
	flame_area = Area2D.new()
	add_child(flame_area)
	var flame_shape = CollisionShape2D.new()
	var rect_shape = RectangleShape2D.new()
	rect_shape.extents = Vector2(get_stat("flame_range") / 2, 25)
	flame_shape.shape = rect_shape
	flame_area.add_child(flame_shape)
	flame_area.position = Vector2(get_stat("flame_range") / 2, 0)

func _physics_process(delta):
	super._physics_process(delta)
	update_flame_position()

func update_flame_position():
	if flame_area:
		flame_area.global_rotation = global_rotation
		flame_area.position = Vector2(get_stat("flame_range") / 2, 0).rotated(rotation)

func shoot():
	var bodies = flame_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies") and body.has_method("take_damage"):
			body.take_damage(get_stat("damage"))
			print("Flame damage applied to enemy: {get_stat('damage')}")

# Opcional: sobrescribe aim_at_nearest_enemy si quieres un comportamiento específico para el lanzallamas
