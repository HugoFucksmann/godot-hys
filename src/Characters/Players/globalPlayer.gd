extends CharacterBody2D

signal health_depleted

@onready var global_state = get_node("/root/GlobalState")
@onready var stats_manager = get_node("/root/StatsManager")

var can_shoot: bool = true
var bullet_scene = preload("res://src/Items/Weapons/gun/bullet.tscn")

func _ready():
	update_stats()
	stats_manager.connect("stats_updated", update_stats)

func update_stats():
	%ProgressBar.max_value = stats_manager.get_stat("max_health")
	%ProgressBar.value = stats_manager.current_health

func _physics_process(delta):
	move_character()
	animate_character()
	check_damage(delta)

func move_character():
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * stats_manager.get_stat("speed")
	move_and_slide()

func animate_character():
	if velocity.length() > 0.0:
		play_walk_animation()
	else:
		play_idle_animation()

func check_damage(delta):
	const DAMAGE_RATE = 50.0
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		take_damage(DAMAGE_RATE * overlapping_mobs.size() * delta)

func take_damage(amount):
	var actual_damage = stats_manager.take_damage(amount)
	%ProgressBar.value = stats_manager.current_health
	if not stats_manager.is_alive():
		global_state.deaths += 1
		health_depleted.emit()

func shoot():
	if can_shoot:
		var bullet = bullet_scene.instantiate()
		bullet.global_position = global_position
		bullet.rotation = global_position.direction_to(get_global_mouse_position()).angle()
		bullet.damage = stats_manager.calculate_damage("distance")
		get_parent().add_child(bullet)
		
		can_shoot = false
		await get_tree().create_timer(1.0 / stats_manager.get_stat("attack_speed")).timeout
		can_shoot = true

# Estos métodos serán sobrescritos en las clases hijas
func play_walk_animation():
	pass

func play_idle_animation():
	pass
