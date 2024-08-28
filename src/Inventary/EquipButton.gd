extends Button

signal equip_requested(item: GlobalItem)

var current_item: GlobalItem = null

func set_item(item: GlobalItem):
	current_item = item
	text = "Equipar " + item.name if item else "Equipar"
	disabled = item == null

func _ready():
	connect("pressed", _on_pressed)

func _on_pressed():
	if current_item:
		emit_signal("equip_requested", current_item)
		current_item = null
		text = "Equipar"
		disabled = true
