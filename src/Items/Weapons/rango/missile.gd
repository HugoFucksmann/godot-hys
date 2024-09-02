extends Area2D

var damage: int = 5
var explosion_radius: float = 100.0
var travelled_distance = 0

func _physics_process(delta):
	const SPEED = 500
	const RANGE = 1000
	
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	travelled_distance += SPEED * delta
	if travelled_distance > RANGE:
		explode()

func _on_body_entered(body):
	explode()

func explode():
	var bodies = get_tree().get_nodes_in_group("enemies")
	for body in bodies:
		var distance = global_position.distance_to(body.global_position)
		if distance <= explosion_radius:
			var damage_multiplier = 1 - (distance / explosion_radius)
			body.take_damage(int(damage * damage_multiplier))
	
	# Aquí puedes añadir efectos visuales de explosión
	queue_free()
