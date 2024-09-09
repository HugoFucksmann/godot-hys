extends Area2D
class_name GlobalBullet

@export var damage: int = 1
@export var speed: float = 1000
@export var max_range: float = 1200
var travelled_distance: float = 0
var is_area_damage: bool = false
var area_damage_radius: float = 0

func _ready():
	print("Bullet created with damage: ", damage)
	# Set up collision mask to only detect enemies
	set_collision_mask_value(1, false)  # Disable collision with players (assuming they're on layer 1)
	set_collision_mask_value(2, true)   # Enable collision with enemies (assuming they're on layer 2)

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta
	travelled_distance += speed * delta
	if travelled_distance > max_range:
		print("Bullet exceeded max range")
		queue_free()

func _on_body_entered(body):
	print("Bullet collided with: ", body.name)
	if body.is_in_group("enemies"):
		if is_area_damage:
			explode()
		else:
			if body.has_method("take_damage"):
				print("Applying damage to enemy: ", body.name)
				body.take_damage(damage)
			queue_free()
	else:
		print("Bullet collided with non-enemy object: ", body.name)
		queue_free()

func explode():
	print("Bullet exploding")
	var explosion_effect = preload("res://src/Characters/smoke_explosion/smoke_explosion.tscn").instantiate()
	explosion_effect.global_position = global_position
	get_tree().current_scene.add_child(explosion_effect)
	
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		var distance = global_position.distance_to(enemy.global_position)
		if distance <= area_damage_radius:
			var damage_multiplier = 1 - (distance / area_damage_radius)
			var applied_damage = int(damage * damage_multiplier)
			print("Applying area damage to enemy: ", enemy.name, " - Damage: ", applied_damage)
			enemy.take_damage(applied_damage)
	
	queue_free()
