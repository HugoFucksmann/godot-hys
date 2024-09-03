extends CharacterBody2D

signal health_depleted

@onready var global_state = get_node("/root/GlobalState")

var health: float
var can_shoot: bool = true
var bullet_scene = preload("res://src/Items/Weapons/gun/bullet.tscn")  # Asegúrate de que esta ruta sea correcta

func _ready():
	update_stats()
	

func update_stats():
	health = StatsManager.get_stat("health")
	%ProgressBar.max_value = StatsManager.get_stat("max_health")
	%ProgressBar.value = health

func _physics_process(delta):
	move_character()
	animate_character()
	check_damage(delta)
	

func move_character():
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * StatsManager.get_stat("speed")
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
	health -= amount
	%ProgressBar.value = health
	if health <= 0.0:
		global_state.deaths += 1
		health_depleted.emit()


func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position
	bullet.rotation = global_position.direction_to(get_global_mouse_position()).angle()
	get_parent().add_child(bullet)
	

# Estos métodos serán sobrescritos en las clases hijas
func play_walk_animation():
	pass

func play_idle_animation():
	pass
