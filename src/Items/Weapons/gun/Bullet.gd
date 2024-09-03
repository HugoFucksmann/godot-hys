extends Area2D
class_name Bullet


var travelled_distance: float = 0.0

func _ready():
	var speed = StatsManager.get_stat("speed")
	var max_range = StatsManager.get_stat("distance_damage")
	var damage = StatsManager.get_stat("damage")

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * StatsManager.get_stat("speed") * delta
	travelled_distance += StatsManager.get_stat("speed") * delta
	if travelled_distance > StatsManager.get_stat("distance_damage"):
		queue_free()

func _on_body_entered(body):
	print("Bullet hit something!")
	if body.is_in_group("enemies") and body.has_method("take_damage"):
		body.take_damage(int(StatsManager.get_stat("damage")))
		print("Aplicando daño al enemigo: ", StatsManager.get_stat("damage"))
	queue_free()

func explode():
	print("Exploding with radius: ", StatsManager.get_stat("area_damage_radius"))
	var enemies = get_tree().get_nodes_in_group("enemies")
	print("Found ", enemies.size(), " enemies in the scene")
	for enemy in enemies:
		var distance = global_position.distance_to(enemy.global_position)
		print("Distance to enemy: ", distance)
		if distance <= StatsManager.get_stat("area_damage_radius"):
			var damage_multiplier = 1 - (distance / StatsManager.get_stat("area_damage_radius"))
			var final_damage = int(StatsManager.get_stat("damage") * damage_multiplier)
			print("Aplicando ", final_damage, " de daño al enemigo")
			if enemy.has_method("take_damage"):
				enemy.take_damage(final_damage)
	
	queue_free()
