extends Node

signal item_equipped(item: BaseItem, slot: String)
signal item_unequipped(item: BaseItem, slot: String)

@onready var equipment_slots: Dictionary = {
	"arma": $WeaponSlot,
	"guantes": $GloveSlot,
	"botas": $BootSlot,
	"armadura": $ArmorSlot,
	"casco": $HelmetSlot,
	"accesorio": $AccessorySlot
}

var default_textures: Dictionary = {
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
			update_slot_texture(slot_name, null)

func equip_item(item: BaseItem) -> bool:
	var item_type_string: String = BaseItem.ItemType.keys()[item.item_type].to_lower()
	if item_type_string in GlobalState.equipped_items:
		if GlobalState.equipped_items[item_type_string]:
			unequip_item(item_type_string)
		GlobalState.equipped_items[item_type_string] = item
		update_slot_texture(item_type_string, item.icon)
		emit_signal("item_equipped", item, item_type_string)
		GlobalState.update_equipped_items()
		return true
	return false

func unequip_item(slot: String) -> BaseItem:
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
			unequip_item(slot_name)
