extends CharacterBody2D

class_name GlobalEnemy

@export var health: int
@export var damage: int
@export var score: int

var player

func _ready():
	player = get_node("/root/Game/Player")  # Ajusta esta ruta según tu árbol de escena
	initialize()  # Método para inicializar características específicas del enemigo

func _physics_process(delta):
	if player:
		chase_player(delta)

func chase_player(delta):
	# Este método será sobreescrito en los enemigos específicos si es necesario.
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 300.0
	move_and_slide()

func take_damage(amount: int):
	health -= amount
	play_hurt_animation()  # Método para reproducir la animación de daño
	if health <= 0:
		die()

func die():
	PlayerData.score += score
	play_death_effects()  # Método para reproducir efectos al morir
	queue_free()

func play_hurt_animation():
	# Este método se puede sobreescribir en los enemigos específicos para reproducir una animación al recibir daño.
	pass

func play_death_effects():
	# Este método se puede sobreescribir en los enemigos específicos para reproducir efectos al morir.
	pass

func initialize():
	# Método que los enemigos específicos pueden usar para configuraciones adicionales en _ready.
	pass
