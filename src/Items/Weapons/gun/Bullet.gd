extends Area2D
class_name Bullet
@onready var global_state = get_node("/root/GlobalState")

var travelled_distance: float = 0.0

func _ready():
	var speed = global_state.get_stat("speed")
	var max_range = global_state.get_stat("distance_damage")
	var damage = global_state.get_stat("damage")

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * global_state.get_stat("speed") * delta
	travelled_distance += global_state.get_stat("speed") * delta
	if travelled_distance > global_state.get_stat("distance_damage"):
		queue_free()

func _on_body_entered(body):
	print("Bullet hit something!")
	if body.is_in_group("enemies") and body.has_method("take_damage"):
		body.take_damage(int(global_state.get_stat("damage")))
		print("Aplicando daño al enemigo: ", global_state.get_stat("damage"))
	queue_free()

func explode():
	print("Exploding with radius: ", global_state.get_stat("area_damage_radius"))
	var enemies = get_tree().get_nodes_in_group("enemies")
	print("Found ", enemies.size(), " enemies in the scene")
	for enemy in enemies:
		var distance = global_position.distance_to(enemy.global_position)
		print("Distance to enemy: ", distance)
		if distance <= global_state.get_stat("area_damage_radius"):
			var damage_multiplier = 1 - (distance / global_state.get_stat("area_damage_radius"))
			var final_damage = int(global_state.get_stat("damage") * damage_multiplier)
			print("Aplicando ", final_damage, " de daño al enemigo")
			if enemy.has_method("take_damage"):
				enemy.take_damage(final_damage)
	
	queue_free()
