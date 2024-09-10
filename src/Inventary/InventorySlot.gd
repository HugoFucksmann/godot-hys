class_name InventorySlot
extends Control

signal slot_clicked(slot: InventorySlot)

var item: BaseItem = null

@onready var background: ColorRect = $ColorRect
@onready var item_texture: TextureRect = $TextureRect

func _ready():
	mouse_filter = Control.MOUSE_FILTER_PASS
	gui_input.connect(_on_gui_input)
	set_item(null)  # Inicializar el slot como vacío

func set_item(_item: BaseItem):
	item = _item
	if item:
		item_texture.texture = item.icon
		background.color = Color(0.5, 0.5, 0.5)  # Gris cuando hay un item
	else:
		item_texture.texture = null
		background.color = Color.WHITE  # Blanco cuando está vacío
	item_texture.visible = item != null

func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		slot_clicked.emit(self)
