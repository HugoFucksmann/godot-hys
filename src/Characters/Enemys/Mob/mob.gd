extends GlobalEnemy

@export var smoke_scene: PackedScene = preload("res://src/Characters/smoke_explosion/smoke_explosion.tscn")
@export var damage: int = 10  # Daño que causa este enemigo específico
@export var attack_range: float = 50.0  # Rango de ataque del enemigo

func _ready():
	super._ready()
	health = 30  # Establece la vida inicial del enemigo

func initialize():
	$Slime.play_walk()  # Reproduce la animación de caminar al inicializar

func play_hurt_animation():
	$Slime.play_hurt()  # Reproduce la animación de daño cuando el enemigo es golpeado

func play_death_effects():
	# Reproduce los efectos de muerte específicos, como la explosión de humo
	var smoke = smoke_scene.instantiate()
	get_parent().add_child(smoke)
	smoke.global_position = global_position

func _physics_process(delta):
	super._physics_process(delta)  # Llama al método de la clase padre
	if player and global_position.distance_to(player.global_position) <= attack_range:
		attack_player()

func attack_player():
	if GlobalState.has_method("take_damage"):
		GlobalState.take_damage(damage)
		print("Enemigo atacó al jugador por ", damage, " de daño")

# Sobreescribimos el método take_damage para asegurarnos de que se llame a play_hurt_animation
func take_damage(amount: int):
	super.take_damage(amount)  # Llama al método de la clase padre
	play_hurt_animation()  # Aseguramos que se reproduzca la animación de daño
