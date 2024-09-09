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
	print("Updating equipped items")
	equip_item("arma", weapon_node, "res://src/Items/item_arma.tscn")
	equip_item("armadura", armor_node, "res://src/Items/item_armadura.tscn")
	equip_item("casco", helmet_node, "res://src/Items/item_casco.tscn")
	equip_item("botas", boots_node, "res://src/Items/item_botas.tscn")
	equip_item("guantes", gloves_node, "res://src/Items/item_guantes.tscn")
	equip_item("accesorio", accessory_node, "res://src/Items/item_accesorio.tscn")

func equip_item(slot: String, node: Node, base_scene_path: String):
	print("Equipping item for slot: ", slot)
	
	# Remove any existing children
	for child in node.get_children():
		child.queue_free()

	var item_data = GlobalState.equipped_items.get(slot)
	if item_data:
		print("Item data found: ", item_data.to_dict())  # Debug print
		
		# Check if the item type matches the slot
		if not is_item_type_valid_for_slot(item_data.item_type, slot):
			print("Warning: Item type does not match slot. Item: ", item_data.name, ", Slot: ", slot)
			return
		
		var base_scene = load(base_scene_path)
		if base_scene:
			print("Base scene loaded: ", base_scene_path)
			var item_instance = base_scene.instantiate()
			print("Item instance created: ", item_instance)
			if item_instance.has_method("initialize"):
				item_instance.initialize(item_data)
				print("Item initialized")
			elif item_instance.has_method("set_item_data"):
				item_instance.set_item_data(item_data)
				print("Item data set")
			else:
				push_error("Error: Item instance does not have initialize or set_item_data method: " + base_scene_path)
				return
			node.add_child(item_instance)
			print("Item added to scene: ", item_instance.name)
			
			# Make sure the item is visible
			if item_instance is CanvasItem:
				item_instance.visible = true
				print("Item visibility set to true")
			
			# Position the item (adjust as needed)
			item_instance.position = Vector2.ZERO
			print("Item position set to ", item_instance.position)
		else:
			push_error("Error: Could not load scene: " + base_scene_path)
	else:
		print("No item data for slot: ", slot)

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
