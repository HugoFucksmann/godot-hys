extends CharacterBody2D

signal health_depleted

@onready var global_state = get_node("/root/GlobalState")
@onready var stats_manager = get_node("/root/StatsManager")
@onready var weapon_node = $WeaponNode  # Nodo donde se mostrará el arma equipada

var can_shoot: bool = true
@export var bullet_scene: PackedScene

func _ready():
	update_stats()
	stats_manager.connect("stats_updated", update_stats)
	_on_equipped_items_changed()

func update_stats():
	%ProgressBar.max_value = stats_manager.get_stat("max_health")
	%ProgressBar.value = stats_manager.current_health
	print("Player health updated to: ", stats_manager.current_health)

func _physics_process(delta):
	move_character()
	animate_character()

func move_character():
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * stats_manager.get_stat("speed")
	move_and_slide()

func animate_character():
	if velocity.length() > 0.0:
		play_walk_animation()
	else:
		play_idle_animation()

func take_damage(amount):
	var actual_damage = stats_manager.take_damage(amount)
	%ProgressBar.value = stats_manager.current_health
	print("Player took damage: ", actual_damage)
	if not stats_manager.is_alive():
		global_state.deaths += 1
		health_depleted.emit()

func shoot():
	if can_shoot:
		var bullet = bullet_scene.instantiate() as GlobalBullet
		if bullet:
			bullet.global_position = global_position
			bullet.rotation = global_position.direction_to(get_global_mouse_position()).angle()
			bullet.damage = stats_manager.calculate_damage("distance")
			
			# Configura la bala para detectar colisiones con enemigos
			bullet.collision_mask = 0b10  # Asume que la capa 2 es para enemigos
			
			get_parent().add_child(bullet)
			print("Bullet created at position: ", bullet.global_position)
			
			can_shoot = false
			await get_tree().create_timer(1.0 / stats_manager.get_stat("attack_speed")).timeout
			can_shoot = true
		else:
			print("Error: Failed to instantiate bullet")

# Método para actualizar el arma equipada
func _on_equipped_items_changed():
	if weapon_node:
		# Limpiar cualquier arma equipada actualmente
		if weapon_node.get_child_count() > 0:
			weapon_node.get_child(0).queue_free()

		var weapon_data = global_state.equipped_items.get("arma", null)
		if weapon_data:
			if typeof(weapon_data.weapon_scene) == TYPE_OBJECT and weapon_data.weapon_scene is PackedScene:
				var weapon_instance = weapon_data.weapon_scene.instantiate()
				weapon_node.add_child(weapon_instance)
			elif typeof(weapon_data.weapon_scene) == TYPE_STRING:
				var weapon_scene = load(weapon_data.weapon_scene)
				if weapon_scene and weapon_scene is PackedScene:
					var weapon_instance = weapon_scene.instantiate()
					weapon_node.add_child(weapon_instance)
			else:
				print("Error: weapon_scene is not a valid PackedScene or resource path")
		else:
			print("No weapon equipped")
	else:
		print("Error: WeaponNode not found")

# Estos métodos serán sobrescritos en las clases hijas
func play_walk_animation():
	pass

func play_idle_animation():
	pass
