extends Node

signal item_equipped(item: GlobalItem, slot: String)
signal item_unequipped(item: GlobalItem, slot: String)

@onready var equipment_slots: Dictionary = {
	"arma": $WeaponSlot,
	"guantes": $GloveSlot,
	"botas": $BootSlot,
	"armadura": $ArmorSlot,
	"casco": $HelmetSlot,
	"accesorio": $AccessorySlot
}

const DEFAULT_SLOT_TEXTURE = preload("res://assets/inventary/slot.png")
@onready var default_textures: Dictionary = {}

func _ready():
	for slot in equipment_slots.keys():
		default_textures[slot] = DEFAULT_SLOT_TEXTURE
	for slot_name in equipment_slots:
		var slot = equipment_slots[slot_name]
		if slot:
			slot.gui_input.connect(_on_slot_gui_input.bind(slot_name))
			update_slot_texture(slot_name, null)
	
	# Conectar la señal de GlobalState para actualizar la UI cuando cambian los items equipados
	GlobalState.connect("equipped_items_updated", _on_equipped_items_updated)

func equip_item(item: GlobalItem) -> bool:
	var item_type_string: String = GlobalItem.ItemType.keys()[item.item_type].to_lower()
	if item_type_string in GlobalState.equipped_items:
		if GlobalState.equipped_items[item_type_string]:
			unequip_item(item_type_string)
		GlobalState.equipped_items[item_type_string] = item
		update_slot_texture(item_type_string, item.icon)
		emit_signal("item_equipped", item, item_type_string)
		GlobalState.update_equipped_items()
		return true
	return false

func unequip_item(slot: String) -> GlobalItem:
	if slot in GlobalState.equipped_items and GlobalState.equipped_items[slot]:
		var item = GlobalState.equipped_items[slot]
		GlobalState.equipped_items[slot] = null
		update_slot_texture(slot, null)
		emit_signal("item_unequipped", item, slot)
		GlobalState.update_equipped_items()
		return item
	return null

func update_slot_texture(slot: String, texture: Texture2D):
	if slot in equipment_slots and equipment_slots[slot]:
		var slot_node = equipment_slots[slot]
		var texture_to_set = texture if texture else default_textures[slot]
		
		if slot_node is TextureRect:
			slot_node.texture = texture_to_set
		else:
			var texture_rect = slot_node.get_node_or_null("TextureRect")
			if texture_rect and texture_rect is TextureRect:
				texture_rect.texture = texture_to_set

func _on_slot_gui_input(event: InputEvent, slot_name: String):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if GlobalState.equipped_items[slot_name]:
			var unequipped_item = unequip_item(slot_name)
			if unequipped_item:
				get_parent().handle_unequipped_item(unequipped_item)

func _on_equipped_items_updated():
	for slot in GlobalState.equipped_items:
		var item = GlobalState.equipped_items[slot]
		if item and item is GlobalItem:  # Verificar que el item sea válido y de tipo GlobalItem
			update_slot_texture(slot, item.icon)
		else:
			update_slot_texture(slot, null)
