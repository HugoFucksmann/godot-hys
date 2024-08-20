extends CharacterBody2D

class_name GlobalCharacter

signal health_depleted
signal item_equipped

# Propiedades configurables globalmente
var health: float
var speed: float
var damage_rate: float
var power: float = 0.0
var defense: float = 0.0

# Equipamiento
var equipped_items = {
	GlobalWeapon.ItemType.WEAPON: null,
	GlobalWeapon.ItemType.ARMOR: null,
	GlobalWeapon.ItemType.BOOTS: null,
	GlobalWeapon.ItemType.HELMET: null,
	GlobalWeapon.ItemType.GLOVES: null,
	GlobalWeapon.ItemType.ACCESSORY: null
}

# Método para inicializar los valores del personaje
func initialize_character(_health: float, _speed: float, _damage_rate: float):
	health = _health
	speed = _speed
	damage_rate = _damage_rate

func equip_item(item):
	equipped_items[item.item_type] = item
	update_stats()
	emit_signal("item_equipped", item)

func update_stats():
	power = 0.0
	defense = 0.0
	for item in equipped_items.values():
		if item != null:
			power += item.item_power
			defense += item.item_defense
	# Actualiza las estadísticas del personaje
	# Suma los valores a las estadísticas base
	damage_rate += power  # Ejemplo de cómo podría afectar el equipamiento

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()

	if velocity.length() > 0.0:
		play_walk_animation()
	else:
		play_idle_animation()

	handle_collisions(delta)

func play_walk_animation():
	pass  # Sobreescribe en personajes específicos

func play_idle_animation():
	pass  # Sobreescribe en personajes específicos

func handle_collisions(delta):
	var overlapping_mobs = $HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		health -= damage_rate * overlapping_mobs.size() * delta
		$ProgressBar.value = health
		if health <= 0.0:
			PlayerData.deaths += 1
			health_depleted.emit()
