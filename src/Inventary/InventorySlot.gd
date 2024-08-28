class_name InventorySlot
extends TextureRect

signal slot_clicked(slot: InventorySlot)

var item: GlobalItem = null

func set_item(_item: GlobalItem):
	item = _item
	if item:
		texture = item.icon
	else:
		texture = null

func _ready():
	mouse_filter = Control.MOUSE_FILTER_PASS
	connect("gui_input", _on_gui_input)

func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("slot_clicked", self)
