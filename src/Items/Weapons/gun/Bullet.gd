extends Area2D

@export var damage: int = 1
var speed: float = 1000
var max_range: float = 1200

var travelled_distance: float = 0
var is_area_damage: bool = false
var area_damage_radius: float = 0

func _physics_process(delta):
	const SPEED = 1000
	const RANGE = 1200
	
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	travelled_distance += SPEED * delta
	if travelled_distance > RANGE:
		queue_free()

func _on_body_entered(body):
	print("Bullet hit something!")
	if is_area_damage:
		print("Activating area damage!")
		explode()
	else:
		print("Applying single target damage")
		if body and body.has_method("take_damage"):
			body.take_damage(damage)
		queue_free()

func explode():
	print("Exploding with radius: ", area_damage_radius)
	var enemies = get_tree().get_nodes_in_group("enemies")
	print("Found ", enemies.size(), " enemies in the scene")
	for enemy in enemies:
		var distance = global_position.distance_to(enemy.global_position)
		print("Distance to enemy: ", distance)
		if distance <= area_damage_radius:
			var damage_multiplier = 1 - (distance / area_damage_radius)
			var final_damage = int(damage * damage_multiplier)
			print("Applying ", final_damage, " damage to enemy")
			enemy.take_damage(final_damage)
	
	queue_free()
