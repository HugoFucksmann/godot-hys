extends Panel

var itemClass = preload("res://src/Items/Weapons/gun/area_gun.tscn")
var item = null

func _ready():
	item = itemClass.instantiate()
	add_child(item)
