class_name InventorySlot
extends TextureButton

signal slot_clicked(slot: InventorySlot)

var item: Item = null

func set_item(_item: Item):
	item = _item
	# Actualizar la textura del botón con el ícono del ítem

func _ready():
	connect("pressed", _on_pressed)

func _on_pressed():
	emit_signal("slot_clicked", self)
