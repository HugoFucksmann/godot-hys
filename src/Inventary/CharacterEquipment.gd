extends Node

signal item_equipped(item: GlobalItem, slot: String)
signal item_unequipped(item: GlobalItem, slot: String)
signal stats_updated(new_stats: Dictionary)

var equipment = {
	"arma": null,
	"guantes": null,
	"botas": null,
	"armadura": null,
	"casco": null,
	"accesorio": null
}

var base_stats = {
	"ataque": 10,
	"defensa": 5,
	"velocidad": 3
}

@onready var equipment_slots = {
	"arma": $WeaponSlot,
	"guantes": $GloveSlot,
	"botas": $BootSlot,
	"armadura": $ArmorSlot,
	"casco": $HelmetSlot,
	"accesorio": $AccessorySlot
}

var default_textures = {
	"arma": preload("res://assets/inventary/slot.png"),
	"guantes": preload("res://assets/inventary/slot.png"),
	"botas": preload("res://assets/inventary/slot.png"),
	"armadura": preload("res://assets/inventary/slot.png"),
	"casco": preload("res://assets/inventary/slot.png"),
	"accesorio": preload("res://assets/inventary/slot.png")
}

func _ready():
	for slot_name in equipment_slots:
		var slot = equipment_slots[slot_name]
		if slot:
			slot.gui_input.connect(_on_slot_gui_input.bind(slot_name))
			# Inicializar slots con textura por defecto
			update_slot_texture(slot_name, null)

func equip_item(item: GlobalItem) -> bool:
	var item_type_string = GlobalItem.ItemType.keys()[item.item_type].to_lower()
	if item_type_string in equipment:
		print("Equipping item: ", item.name)  # Debug
		if equipment[item_type_string]:
			unequip_item(item_type_string)
		equipment[item_type_string] = item
		update_slot_texture(item_type_string, item.icon)
		emit_signal("item_equipped", item, item_type_string)
		update_stats()
		return true
	print("Failed to equip item: ", item.name)  # Debug
	return false

func unequip_item(slot: String) -> GlobalItem:
	if slot in equipment and equipment[slot]:
		var item = equipment[slot]
		print("Unequipping item: ", item.name)  # Debug
		equipment[slot] = null
		update_slot_texture(slot, null)
		emit_signal("item_unequipped", item, slot)
		update_stats()
		GlobalState.handle_unequipped_item(item)
		return item
	print("No item to unequip in slot: ", slot)  # Debug
	return null

func update_slot_texture(slot: String, texture: Texture2D):
	if slot in equipment_slots and equipment_slots[slot]:
		var slot_node = equipment_slots[slot]
		var texture_to_set = texture if texture else default_textures[slot]
		
		if slot_node is TextureRect:
			slot_node.texture = texture_to_set
		else:
			# Buscar un hijo TextureRect si el nodo no es directamente un TextureRect
			var texture_rect = slot_node.get_node_or_null("TextureRect")
			if texture_rect and texture_rect is TextureRect:
				texture_rect.texture = texture_to_set

func update_stats():
	var total_stats = base_stats.duplicate()
	for slot in equipment:
		var item = equipment[slot]
		if item:
			for stat in item.stats:
				if stat in total_stats:
					total_stats[stat] += item.stats[stat]
	emit_signal("stats_updated", total_stats)

func _on_slot_gui_input(event: InputEvent, slot_name: String):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if equipment[slot_name]:
			unequip_item(slot_name)
