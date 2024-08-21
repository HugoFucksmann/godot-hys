extends Node
class_name WeaponManager
# Lista de todas las armas en el juego
var weapons = []

# Referencia al enemigo más cercano
var closest_enemy = null

# Función para agregar un arma al manager
func add_weapon(weapon):
	weapons.append(weapon)
	weapon.connect("detected_enemy", _on_enemy_detected)
	weapon.connect("lost_enemy", _on_enemy_lost)

# Función para encontrar el enemigo más cercano
func _process(delta):
	closest_enemy = find_closest_enemy()
	update_weapon_targets()

# Función para actualizar los objetivos de las armas
func update_weapon_targets():
	for weapon in weapons:
		weapon.set_target(closest_enemy)

# Función para disparar todas las armas que tengan un enemigo en rango
func _on_enemy_detected(enemy):
	for weapon in weapons:
		weapon.start_shooting()

# Función para dejar de disparar cuando se pierde el enemigo
func _on_enemy_lost(enemy):
	for weapon in weapons:
		weapon.stop_shooting()

# Función auxiliar para encontrar el enemigo más cercano
func find_closest_enemy():
	var closest_distance = INF
	var closest_enemy = null
	for enemy in get_tree().get_nodes_in_group("enemies"):
		var distance = enemy.global_position.distance_to(global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_enemy = enemy
	return closest_enemy
