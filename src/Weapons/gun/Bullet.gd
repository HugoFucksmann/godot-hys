extends Area2D
@export var damage: int = 1
var travelled_distance = 0

func _physics_process(delta):
	const SPEED = 1000
	const RANGE = 1200
	
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	travelled_distance += SPEED * delta
	if travelled_distance > RANGE:
		queue_free()


func _on_body_entered(body):
	queue_free()  # La bala se destruye al colisionar
	if body and body.has_method("take_damage"):
		body.take_damage(damage)
	
