# BulletSystem.gd
extends Node
class_name BulletSystem

enum BulletType {LASER, SNIPER, FLAMING, AREA, NORMAL, SHOTGUN}

class LaserBullet extends GlobalBullet:
	var bounce_count = 0
	const MAX_BOUNCES = 5

	func hit(body):
		if body and body.has_method("take_damage"):
			body.take_damage(damage)
			bounce_count += 1
			if bounce_count < MAX_BOUNCES:
				find_next_target()
			else:
				queue_free()

	func find_next_target():
		# Lógica para encontrar el siguiente enemigo más cercano
		pass

class SniperBullet extends GlobalBullet:
	func _physics_process(delta):
		# Atraviesa a todos los enemigos en línea recta
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(global_position, global_position + Vector2.RIGHT.rotated(rotation) * 1000)
		query.exclude = [self]
		var result = space_state.intersect_ray(query)
		if result:
			if result.collider.has_method("take_damage"):
				result.collider.take_damage(damage)

class FlamingBullet extends GlobalBullet:
	func _physics_process(delta):
		# Daña a todos los enemigos en un cono frente al jugador
		var bodies = get_overlapping_bodies()
		for body in bodies:
			if body.has_method("take_damage") and is_in_cone(body):
				body.take_damage(damage)

	func is_in_cone(body):
		# Implementar lógica para verificar si el cuerpo está en el cono
		return true  # Placeholder, implementa la lógica real aquí

class AreaBullet extends GlobalBullet:
	func _physics_process(delta):
		# Daña en un área
		var bodies = get_overlapping_bodies()
		for body in bodies:
			if body.has_method("take_damage"):
				body.take_damage(damage)

class NormalBullet extends GlobalBullet:
	pass # Usa la implementación por defecto de GlobalBullet

static func instance_bullet(type: BulletType, position: Vector2, rotation: float, damage: int) -> GlobalBullet:
	var bullet: GlobalBullet
	match type:
		BulletType.LASER:
			bullet = LaserBullet.new()
		BulletType.SNIPER:
			bullet = SniperBullet.new()
		BulletType.FLAMING:
			bullet = FlamingBullet.new()
		BulletType.AREA:
			bullet = AreaBullet.new()
		BulletType.NORMAL, BulletType.SHOTGUN:
			bullet = NormalBullet.new()
	
	if bullet:
		bullet.global_position = position
		bullet.global_rotation = rotation
		bullet.damage = damage
	
	return bullet

static func shoot(type: BulletType, position: Vector2, rotation: float, damage: int):
	var scene_tree = Engine.get_main_loop()
	if scene_tree:
		var current_scene = scene_tree.current_scene
		match type:
			BulletType.SHOTGUN:
				for i in range(5):
					var spread = deg_to_rad(randf_range(-15, 15))
					var bullet = instance_bullet(BulletType.NORMAL, position, rotation + spread, damage)
					current_scene.add_child(bullet)
			_:
				var bullet = instance_bullet(type, position, rotation, damage)
				current_scene.add_child(bullet)
