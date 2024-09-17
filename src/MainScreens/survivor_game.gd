extends Node2D

signal mission_completed(mission_number: int)

var enemy_manager: EnemyManager
var player: CharacterBody2D
var ui_layer: CanvasLayer
@onready var timer: Timer = $Timer  # Referencia al Timer existente
@onready var game_over_screen: Control = $GameOverScreen  # Referencia a la pantalla de Game Over

var mission_number: int = 1
var level_number: int = 1
var time_remaining: float = 60.0
var missions_completed: int = 0

func _ready():
	setup_game()
	if player:
		player.connect("health_depleted", Callable(self, "_on_player_died"))

func setup_game():
	create_player()
	create_enemy_manager()
	create_ui()
	setup_timer()  # Configurar el Timer existente
	start_game()

func create_player():
	# Primero, verificamos si ya existe un jugador en la escena
	player = get_node_or_null("Player")
	if player:
		print("Player already exists in the scene")
	else:
		var player_scene = load("res://src/Players/player.tscn")
		if player_scene:
			player = player_scene.instantiate()
			if player:
				player.name = "Player"  # Asignamos un nombre único
				add_child(player)
				player.position = get_viewport_rect().size / 2
			else:
				print("Error: Failed to instantiate player scene")
				create_fallback_player()
		else:
			print("Error: Failed to load player scene")
			create_fallback_player()
			
func create_fallback_player():
	player = CharacterBody2D.new()
	player.name = "Player"  # Asignamos un nombre único
	var sprite = Sprite2D.new()
	sprite.texture = load("res://icon.png")  # Asegúrate de que este archivo exista
	player.add_child(sprite)
	add_child(player)
	player.position = get_viewport_rect().size / 2
	
func create_enemy_manager():
	enemy_manager = EnemyManager.new(player)
	add_child(enemy_manager)

func create_ui():
	ui_layer = CanvasLayer.new()
	add_child(ui_layer)
	
	var timer_label = Label.new()
	timer_label.name = "TimerLabel"
	timer_label.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	timer_label.offset_right = -10
	timer_label.offset_top = 10
	ui_layer.add_child(timer_label)
	
	var mission_label = Label.new()
	mission_label.name = "MissionLabel"
	mission_label.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	mission_label.offset_left = 10
	mission_label.offset_top = 10
	ui_layer.add_child(mission_label)

func setup_timer():
	timer.wait_time = 2.0  # Ajusta el tiempo entre spawns según sea necesario
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	timer.one_shot = false

func start_game():
	reset_game_state()
	update_ui()
	start_spawning_enemies()  # Iniciar el spawn de enemigos

func reset_game_state():
	time_remaining = 60.0
	missions_completed = 0
	level_number = 1
	update_difficulty()

func _process(delta):
	time_remaining -= delta
	update_ui()
	
	if time_remaining <= 0:
		end_level()

func update_ui():
	var timer_label = ui_layer.get_node("TimerLabel")
	timer_label.text = "Time: %0.1f" % time_remaining
	
	var mission_label = ui_layer.get_node("MissionLabel")
	mission_label.text = "Mission %d - Level %d" % [mission_number, level_number]

func end_level():
	timer.stop()  # Detener el Timer de spawn cuando termine el tiempo de la partida
	level_number += 1
	missions_completed += 1
	
	if missions_completed >= 10:
		complete_mission()
	else:
		start_next_level()

func start_next_level():
	time_remaining = 60.0
	update_difficulty()
	start_spawning_enemies()

func complete_mission():
	emit_signal("mission_completed", mission_number)
	mission_number += 1
	level_number = 1
	missions_completed = 0
	start_next_level()

func update_difficulty():
	var difficulty = (mission_number - 1) * 10 + level_number
	enemy_manager.set_difficulty(difficulty)

func start_spawning_enemies():
	timer.start()  # Iniciar el Timer de spawn

func _on_timer_timeout():
	spawn_enemies()

func spawn_enemies():
	var num_enemies = 1  # Cambiado para generar un enemigo a la vez
	for i in range(num_enemies):
		var enemy_type = enemy_manager.get_random_enemy_for_level(level_number)
		var spawn_position = get_random_spawn_position()
		var enemy = enemy_manager.spawn_enemy(enemy_type, spawn_position)
		if enemy:
			add_child(enemy)

func get_random_spawn_position() -> Vector2:
	var viewport_size = get_viewport_rect().size
	var spawn_margin = 100
	var x = randf_range(-spawn_margin, viewport_size.x + spawn_margin)
	var y = randf_range(-spawn_margin, viewport_size.y + spawn_margin)
	return Vector2(x, y)

func _on_player_died():
	# Lógica para manejar la muerte del jugador
	pass
