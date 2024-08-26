extends Node

@onready var inventory = $Inventory
@onready var character_equipment = $CharacterEquipment
@onready var inventory_slots = $InventoryPanel/SlotsContainer
@onready var equip_button = $InventoryPanel/EquipButton


func _ready():
	# Conectar señales de los slots de inventario
	for slot in inventory_slots.get_children():
		if slot is InventorySlot:
			slot.slot_clicked.connect(_on_inventory_slot_clicked)
	
	# Conectar señal del botón de equipar
	equip_button.connect("pressed", _on_equip_button_pressed)
	equip_button.hide()
	var sword = Item.new("Espada", "arma", {"ataque": 5})
	var shield = Item.new("Escudo", "accesorio", {"defensa": 3})
	inventory.add_item(sword)
	inventory.add_item(shield)
	update_inventory_ui()
	
func _on_inventory_slot_clicked(slot: InventorySlot):
	if slot.item:
		equip_button.set_item(slot.item)
		equip_button.show()
	else:
		equip_button.hide()

func _on_equip_requested(item: Item):
	var index = inventory.items.find(item)
	if index != -1:
		if character_equipment.equip_item(item):
			inventory.remove_item(index)
			update_inventory_ui()
	equip_button.hide()

func _on_equip_button_pressed():
	var item = equip_button.current_item
	if item:
		var index = inventory.items.find(item)
		if index != -1:
			if character_equipment.equip_item(item):
				inventory.remove_item(index)
				update_inventory_ui()
		equip_button.hide()

func update_inventory_ui():
	for i in range(inventory_slots.get_child_count()):
		var slot = inventory_slots.get_child(i)
		if i < inventory.items.size():
			slot.set_item(inventory.items[i])
		else:
			slot.set_item(null)
