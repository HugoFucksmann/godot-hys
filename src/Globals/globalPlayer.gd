extends CharacterBody2D

signal health_depleted

@onready var equipment_nodes = {
	"arma": $WeaponNode,
	"armadura": $ArmorNode,
	"casco": $HelmetNode,
	"botas": $BootsNode,
	"guantes": $GlovesNode,
	"accesorio": $AccessoryNode
}

var can_shoot: bool = true

func _ready():
	update_stats()
	StatsManager.connect("stats_updated", Callable(self, "update_stats"))
	
	_on_equipped_items_changed()  # Asegurarnos de que los ítems equipados se configuren correctamente al inicio
	set_collision_layer_value(1, true)
	set_collision_layer_value(2, false)

func update_stats():
	%ProgressBar.max_value = StatsManager.get_stat("max_health")
	%ProgressBar.value = StatsManager.current_health

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * StatsManager.get_stat("speed")
	move_and_slide()
	
	if velocity.length() > 0.0:
		play_walk_animation()
	else:
		play_idle_animation()

func take_damage(amount):
	var actual_damage = StatsManager.take_damage(amount)
	%ProgressBar.value = StatsManager.current_health
	if not StatsManager.is_alive():
		GlobalState.deaths += 1
		emit_signal("health_depleted")

func shoot():
	if can_shoot and equipment_nodes["arma"].get_child_count() > 0:
		var weapon = equipment_nodes["arma"].get_child(0) as WeaponItem
		if weapon:
			weapon.shoot(global_position, global_position.direction_to(get_global_mouse_position()))
			can_shoot = false
			await get_tree().create_timer(1.0 / StatsManager.get_stat("attack_speed")).timeout
			can_shoot = true

func _on_equipped_items_changed():
	for slot in equipment_nodes:
		equip_item(slot, equipment_nodes[slot], "res://src/Items/item_" + slot + ".tscn")

	# Añadir lógica para asegurar que el arma esté lista para disparar al inicio
	if equipment_nodes["arma"].get_child_count() > 0:
		var weapon = equipment_nodes["arma"].get_child(0) as WeaponItem
		if weapon:
			weapon.ready_to_shoot()

func equip_item(slot: String, node: Node, base_scene_path: String):
	if not is_instance_valid(node):
		push_warning("Invalid node for slot: " + slot)
		return

	node.get_children().map(func(child): child.queue_free())

	var item_data = GlobalState.equipped_items.get(slot)
	if not item_data or not is_item_type_valid_for_slot(item_data.item_type, slot):
		return

	var base_scene = load(base_scene_path)
	if not base_scene:
		push_error("Failed to load scene: " + base_scene_path)
		return

	var item_instance = base_scene.instantiate()
	if "initialize" in item_instance:
		item_instance.initialize(item_data)
	elif "set_item_data" in item_instance:
		item_instance.set_item_data(item_data)
	else:
		push_error("Item instance lacks required methods: " + base_scene_path)
		return

	node.add_child(item_instance)

	if slot == "arma" and item_instance is WeaponItem:
		item_instance.weapon_fired.connect(Callable(self, "_on_weapon_fired"))

	if item_instance is CanvasItem:
		item_instance.visible = true
		item_instance.position = Vector2.ZERO

func _on_weapon_fired(bullet_scene: PackedScene, position: Vector2, direction: Vector2):
	var bullet = bullet_scene.instantiate()
	bullet.global_position = position
	bullet.rotation = direction.angle()
	bullet.damage = StatsManager.calculate_damage("distance")
	get_tree().current_scene.add_child(bullet)

func is_item_type_valid_for_slot(item_type, slot: String) -> bool:
	return BaseItem.ItemType.keys()[item_type].to_lower() == slot

func _process(delta):
	var nearest_enemy = find_nearest_enemy()
	if nearest_enemy:
		shoot_at_enemy(nearest_enemy)

func find_nearest_enemy():
	return get_tree().get_nodes_in_group("enemies").reduce(func(a, b): return a if global_position.distance_to(a.global_position) < global_position.distance_to(b.global_position) else b)

func shoot_at_enemy(enemy):
	if equipment_nodes["arma"].get_child_count() > 0:
		var weapon = equipment_nodes["arma"].get_child(0) as WeaponItem
		if weapon:
			weapon.shoot(global_position, global_position.direction_to(enemy.global_position))

func play_walk_animation():
	pass

func play_idle_animation():
	pass
