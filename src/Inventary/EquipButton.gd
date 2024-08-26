class_name EquipButton
extends Button

signal equip_requested(item: Item)

var current_item: Item = null

func set_item(_item: Item):
	current_item = _item
	text = "Equipar " + current_item.name

func _on_pressed():
	if current_item:
		emit_signal("equip_requested", current_item)
