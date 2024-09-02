extends Area2D
class_name GlobalBullet

@export var damage: int = 1
@export var speed: float = 1000
@export var max_range: float = 1200

var travelled_distance: float = 0
var is_area_damage: bool = false
var area_damage_radius: float = 0

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta
	travelled_distance += speed * delta
	if travelled_distance > max_range:
		queue_free()

func _on_body_entered(body):
	if is_area_damage:
		explode()
	else:
		if body.has_method("take_damage"):
			body.take_damage(damage)
		queue_free()

func explode():
	var explosion_effect = preload("res://src/Characters/smoke_explosion/smoke_explosion.tscn").instantiate()
	explosion_effect.global_position = global_position
	get_tree().current_scene.add_child(explosion_effect)
	
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		var distance = global_position.distance_to(enemy.global_position)
		if distance <= area_damage_radius:
			var damage_multiplier = 1 - (distance / area_damage_radius)
			enemy.take_damage(int(damage * damage_multiplier))
	
	queue_free()
