# Shotgun.gd
extends GlobalWeapon

func _init():
	fire_rate = 0.5
	damage = 3
	bullet_scene = preload("res://src/Weapons/gun/bullet.tscn")
	
	

func shoot():
	if bullet_scene:
		for i in range(5):  # Dispara 5 balas en abanico
			var new_bullet = bullet_scene.instantiate()
			new_bullet.global_position = shooting_point.global_position
			new_bullet.global_rotation = shooting_point.global_rotation + randf_range(-0.2, 0.2)
			new_bullet.damage = damage
			get_tree().current_scene.add_child(new_bullet)
