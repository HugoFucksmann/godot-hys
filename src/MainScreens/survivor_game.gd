extends Node2D

var enemy_manager: EnemyManager
@onready var timer = $Timer
@onready var player = $Player

var enemy_spawn_positions = []

func _ready():
	print("Game scene ready")
	await get_tree().create_timer(0.1).timeout  # Short delay to ensure player is ready
	enemy_manager = EnemyManager.new(player)
	add_child(enemy_manager)
	setup_enemy_spawn_positions()
	timer.connect("timeout", _on_timer_timeout)
	player.connect("health_depleted", _on_player_health_depleted)

func setup_enemy_spawn_positions():
	# Define las posiciones de spawn de enemigos alrededor del área de juego
	var spawn_margin = 100
	var viewport_size = get_viewport_rect().size
	
	# Arriba
	for x in range(0, viewport_size.x, 200):
		enemy_spawn_positions.append(Vector2(x, -spawn_margin))
	
	# Abajo
	for x in range(0, viewport_size.x, 200):
		enemy_spawn_positions.append(Vector2(x, viewport_size.y + spawn_margin))
	
	# Izquierda
	for y in range(0, viewport_size.y, 200):
		enemy_spawn_positions.append(Vector2(-spawn_margin, y))
	
	# Derecha
	for y in range(0, viewport_size.y, 200):
		enemy_spawn_positions.append(Vector2(viewport_size.x + spawn_margin, y))

func _on_timer_timeout() -> void:
	spawn_enemy()

func spawn_enemy():
	var enemy_types = ["basic_enemy", "fast_enemy"]
	var random_enemy_type = enemy_types[randi() % enemy_types.size()]
	var random_position = enemy_spawn_positions[randi() % enemy_spawn_positions.size()]
	var enemy = enemy_manager.create_enemy(random_enemy_type)
	if enemy:
		add_child(enemy)
		enemy.global_position = random_position
		# Ensure the enemy is properly initialized
		enemy.set_physics_process(true)
		enemy.set_process(true)
		enemy.visible = true
		# Force update of the enemy
		enemy.call_deferred("_physics_process", 0.0)
	else:
		print("Failed to create enemy")

func _on_player_health_depleted() -> void:
	%GameOver.visible = true
	get_tree().paused = true
