extends CharacterBody2D
class_name BaseEnemy

signal enemy_died(score: int)

@export var base_stats: Dictionary = {
	"health": 100,
	"damage": 10,
	"defense": 5,
	"dodge_chance": 5.0,
	"speed": 300.0
}
@export var score: int = 10
@export var damage_interval: float = 0.5  # Tiempo entre cada aplicación de daño

var player: CharacterBody2D
var stats: Dictionary
var current_health: float

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

var is_ready = false
var damage_timer: float = 0.0

func _ready():
	add_to_group("enemies")
	
	is_ready = true
	if player:
		_initialize()

func initialize(player_ref: CharacterBody2D):
	player = player_ref
	if is_ready:
		_initialize()
	else:
		await ready
		_initialize()

func _initialize():
	stats = base_stats.duplicate()
	current_health = stats["health"]
	if sprite:
		sprite.visible = true

func _physics_process(delta):
	if player:
		chase_player(delta)
		check_collision_with_player(delta)

func chase_player(delta):
	if player:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * stats["speed"]
		move_and_slide()

func check_collision_with_player(delta):
	damage_timer += delta
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider() == player and damage_timer >= damage_interval:
			attack_player()
			damage_timer = 0.0

func take_damage(amount: float) -> float:
	if randf() * 100 <= stats["dodge_chance"]:
		return 0.0  # Damage dodged
	var damage_reduction = stats["defense"] / 100.0
	var actual_damage = amount * (1 - damage_reduction)
	current_health -= actual_damage
	current_health = max(current_health, 0)
	play_hurt_animation()
	if current_health <= 0:
		die()
	
	return actual_damage

func die():
	emit_signal("enemy_died", score)
	play_death_animation()
	queue_free()

func play_hurt_animation():
	if animation_player and animation_player.has_animation("hurt"):
		animation_player.play("hurt")

func play_death_animation():
	if animation_player and animation_player.has_animation("death"):
		animation_player.play("death")

func attack_player():
	if player and player.has_method("take_damage"):
		player.take_damage(stats["damage"])
		print("Enemy attacked player for ", stats["damage"], " damage")

func set_stats(_stats: Dictionary):
	stats = _stats.duplicate()
	current_health = stats["health"]

func set_animations(hurt_anim: String, death_anim: String):
	if animation_player:
		if animation_player.has_animation(hurt_anim):
			animation_player.get_animation(hurt_anim).name = "hurt"
		if animation_player.has_animation(death_anim):
			animation_player.get_animation(death_anim).name = "death"

func set_texture(texture_path: String):
	if not is_ready:
		await ready
	var image = Image.new()
	var err = image.load(texture_path)
	if err == OK:
		var texture = ImageTexture.create_from_image(image)
		sprite.texture = texture
	sprite.visible = true
