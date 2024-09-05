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

var player: CharacterBody2D
var stats: Dictionary
var current_health: float

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D



func initialize(player_ref: CharacterBody2D):
	player = player_ref
	stats = base_stats.duplicate()
	current_health = stats["health"]

func _physics_process(delta):
	if player:
		chase_player(delta)

func chase_player(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * stats["speed"]
	move_and_slide()

func take_damage(amount: float) -> float:
	if randf() * 100 <= stats["dodge_chance"]:
		return 0.0  # Daño esquivado
	
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
	if player:
		player.take_damage(stats["damage"])

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
	print("Attempting to load texture from: ", texture_path)

	var image_texture = ResourceLoader.load(texture_path) as ImageTexture

	if image_texture:
		sprite.texture = image_texture
		print("Texture assigned to sprite successfully")
	else:
		print("Failed to load image from texture path: ", texture_path)

	# Verifica que sprite esté inicializado
	if sprite:
		sprite.visible = true
		print("Sprite visible: ", sprite.visible)
	else:
		print("Sprite node is null")
