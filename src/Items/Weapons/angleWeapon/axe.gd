extends GlobalItem

const ATTACK_ANGLE = 90  # Grados del arco de ataque
const ATTACK_RADIUS = 100  # Radio de ataque en píxeles

var attack_area: Area2D

func _init():
	super._init(
		"Axe",
		preload("res://src/Items/Weapons/gun/asset/pistol.png"),
		ItemType.ARMA
	)
	
	set_stats({
		"damage": 3.0,  # Más daño que las armas a distancia
		"attack_speed": 0.8,  # Más lento que la pistola
		"melee_damage": 3.0,
		"pickup_radius": 50
	})

	print("Axe initialized with name:", name)

func _ready():
	super._ready()
	# Crea el Area2D para el ataque
	attack_area = Area2D.new()
	attack_area.name = "AttackArea"
	var attack_shape = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = ATTACK_RADIUS
	attack_shape.shape = shape
	attack_area.add_child(attack_shape)
	add_child(attack_area)

func shoot():
	# Realiza un ataque melee
	var attack_direction = Vector2.RIGHT.rotated(global_rotation)
	var bodies = attack_area.get_overlapping_bodies()
	for body in bodies:
		if body is GlobalEnemy:
			var to_body = body.global_position - global_position
			var angle = abs(to_body.angle_to(attack_direction))
			if angle <= deg_to_rad(ATTACK_ANGLE / 2):
				body.take_damage(int(get_stat("damage")))
