# GlobalBullet.gd
extends Area2D
class_name GlobalBullet

var damage: int = 1
var travelled_distance = 0

func _physics_process(delta):
	move(delta)
	check_range()

func move(delta):
	const SPEED = 1000
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	travelled_distance += SPEED * delta

func check_range():
	const RANGE = 1200
	if travelled_distance > RANGE:
		queue_free()

func _on_body_entered(body):
	hit(body)

func hit(body):
	if body and body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
