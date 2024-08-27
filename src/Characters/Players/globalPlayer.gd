extends CharacterBody2D

signal health_depleted

@export var max_health := 100.0
@export var speed := 600.0

var health: float

func _ready():
	health = max_health
	%ProgressBar.max_value = max_health
	%ProgressBar.value = health

func _physics_process(delta):
	move_character()
	animate_character()
	check_damage(delta)

func move_character():
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
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
		GlobalState.deaths += 1
		health_depleted.emit()

# Estos métodos serán sobrescritos en las clases hijas
func play_walk_animation():
	pass

func play_idle_animation():
	pass
