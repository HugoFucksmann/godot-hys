extends GlobalItem

func _init():
	super._init(
		"Missile Launcher",
		preload("res://src/Items/Weapons/gun/asset/pistol.png"),
		ItemType.ARMA
	)
	
	set_stats({
		"damage": 5,
		"attack_speed": 0.5,
		"distance_damage": 5,
		"pickup_radius": 50
   	})
	set_bullet_scene(preload("res://src/Items/Weapons/gun/bullet.tscn"))
	#set_bullet_scene(preload("res://path/to/Missile.tscn"))
	
func shoot():
	if bullet_scene and shooting_point:
		var new_missile = bullet_scene.instantiate()
		new_missile.global_position = shooting_point.global_position
		new_missile.global_rotation = shooting_point.global_rotation
		new_missile.damage = get_stat("damage")
		get_tree().current_scene.add_child(new_missile)
