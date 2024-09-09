extends CharacterBody2D

signal health_depleted



@onready var weapon_node = $WeaponNode
@onready var armor_node = $ArmorNode
@onready var helmet_node = $HelmetNode
@onready var boots_node = $BootsNode
@onready var gloves_node = $GlovesNode
@onready var accessory_node = $AccessoryNode

var can_shoot: bool = true

func _ready():
	update_stats()
	StatsManager.connect("stats_updated", update_stats)
	GlobalState.debug_print_equipped_items()
	_on_equipped_items_changed()
	
	# Set collision layer for player
	set_collision_layer_value(1, true)   # Enable collision on layer 1 (player)
	set_collision_layer_value(2, false)  # Disable collision on layer 2 (enemies)

func update_stats():
	%ProgressBar.max_value = StatsManager.get_stat("max_health")
	%ProgressBar.value = StatsManager.current_health

func _physics_process(delta):
	move_character()
	animate_character()

func move_character():
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * StatsManager.get_stat("speed")
	move_and_slide()

func animate_character():
	if velocity.length() > 0.0:
		play_walk_animation()
	else:
		play_idle_animation()

func take_damage(amount):
	var actual_damage = StatsManager.take_damage(amount)
	%ProgressBar.value = StatsManager.current_health
	if not StatsManager.is_alive():
		GlobalState.deaths += 1
		health_depleted.emit()

func shoot():
	if can_shoot and weapon_node.get_child_count() > 0:
		var weapon = weapon_node.get_child(0) as WeaponItem
		if weapon:
			weapon.shoot(global_position, global_position.direction_to(get_global_mouse_position()))
			can_shoot = false
			await get_tree().create_timer(1.0 / StatsManager.get_stat("attack_speed")).timeout
			can_shoot = true

func _on_equipped_items_changed():

	equip_item("arma", weapon_node, "res://src/Items/item_arma.tscn")
	equip_item("armadura", armor_node, "res://src/Items/item_armadura.tscn")
	equip_item("casco", helmet_node, "res://src/Items/item_casco.tscn")
	equip_item("botas", boots_node, "res://src/Items/item_botas.tscn")
	equip_item("guantes", gloves_node, "res://src/Items/item_guantes.tscn")
	equip_item("accesorio", accessory_node, "res://src/Items/item_accesorio.tscn")

func equip_item(slot: String, node: Node, base_scene_path: String):
	if not is_instance_valid(node):
		push_warning("Invalid node for slot: " + slot)
		return

	node.get_children().map(func(child): child.queue_free())

	var item_data = GlobalState.equipped_items.get(slot)
	if not item_data or not is_item_type_valid_for_slot(item_data.item_type, slot):
		push_warning("Invalid item data or type for slot: " + slot)
		return

	var base_scene = load(base_scene_path)
	if not base_scene:
		push_error("Failed to load scene: " + base_scene_path)
		return

	var item_instance = base_scene.instantiate()
	if item_instance.has_method("initialize"):
		item_instance.initialize(item_data)
	elif item_instance.has_method("set_item_data"):
		item_instance.set_item_data(item_data)
	else:
		push_error("Item instance lacks required methods: " + base_scene_path)
		return

	node.add_child(item_instance)

	if slot == "arma" and item_instance is WeaponItem:
		item_instance.weapon_fired.connect(_on_weapon_fired)

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
	match slot:
		"arma": return item_type == BaseItem.ItemType.ARMA
		"armadura": return item_type == BaseItem.ItemType.ARMADURA
		"casco": return item_type == BaseItem.ItemType.CASCO
		"botas": return item_type == BaseItem.ItemType.BOTAS
		"guantes": return item_type == BaseItem.ItemType.GUANTES
		"accesorio": return item_type == BaseItem.ItemType.ACCESORIO
	return false

func play_walk_animation():
	pass

func play_idle_animation():
	pass

func _process(delta):
	# Check for nearby enemies and shoot if found
	var nearest_enemy = find_nearest_enemy()
	if nearest_enemy:
		shoot_at_enemy(nearest_enemy)

func find_nearest_enemy():
	var enemies = get_tree().get_nodes_in_group("enemies")
	var nearest_enemy = null
	var nearest_distance = INF
	
	for enemy in enemies:
		var distance = global_position.distance_to(enemy.global_position)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_enemy = enemy
	
	return nearest_enemy

func shoot_at_enemy(enemy):
	if weapon_node.get_child_count() > 0:
		var weapon = weapon_node.get_child(0) as WeaponItem
		if weapon:
			var direction = global_position.direction_to(enemy.global_position)
			weapon.shoot(global_position, direction)
