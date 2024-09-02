extends GlobalItem

const ATTACK_RADIUS = 150  # Radio del área de ataque en píxeles
const ATTACK_OFFSET = 100  # Distancia frente al jugador donde aparece el ataque

var attack_area: Area2D

func _init():
	super._init(
		"FireStaff",
	   preload("res://src/Items/Weapons/gun/asset/pistol.png"),
		ItemType.ARMA
	)
	
	set_stats({
		"damage": 2.5,
		"attack_speed": 1.2,
		"magic_damage": 2.5,
		"pickup_radius": 50
	})

	set_bullet_scene(preload("res://src/Items/Weapons/gun/bullet.tscn"))
	print("FireStaff initialized with name:", name)

func _ready():
	super._ready()
	# Crea el Area2D para el ataque
	attack_area = Area2D.new()
	attack_area.name = "AttackArea"
	var attack_shape = CollisionShape2D.new()
	var circle_shape = CircleShape2D.new()
	circle_shape.radius = ATTACK_RADIUS
	attack_shape.shape = circle_shape
	attack_area.add_child(attack_shape)
	add_child(attack_area)
	attack_area.position = Vector2(ATTACK_OFFSET, 0)  # Coloca el área frente al jugador

func shoot():
	if bullet_scene and shooting_point:
		var new_bullet = bullet_scene.instantiate()
		new_bullet.global_position = shooting_point.global_position + Vector2(ATTACK_OFFSET, 0).rotated(global_rotation)
		new_bullet.global_rotation = global_rotation
		new_bullet.damage = int(get_stat("damage"))
		get_tree().current_scene.add_child(new_bullet)

		# Aplicar daño a los enemigos en el área
		var bodies = attack_area.get_overlapping_bodies()
		for body in bodies:
			if body is GlobalEnemy:
				body.take_damage(int(get_stat("damage")))
