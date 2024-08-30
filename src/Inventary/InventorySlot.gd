class_name InventorySlot
extends Control

signal slot_clicked(slot: InventorySlot)

var item: GlobalItem = null

@onready var background = $ColorRect
@onready var item_texture = $TextureRect

func set_item(_item: GlobalItem):
	item = _item
	if item:
		item_texture.texture = item.icon
		item_texture.visible = true
		background.color = Color(0.5, 0.5, 0.5)  # Gris cuando hay un item
	else:
		item_texture.texture = null
		item_texture.visible = false
		background.color = Color.WHITE  # Blanco cuando está vacío

func _ready():
	mouse_filter = Control.MOUSE_FILTER_PASS
	connect("gui_input", _on_gui_input)
	set_item(null)  # Inicializar el slot como vacío

func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("slot_clicked", self)
