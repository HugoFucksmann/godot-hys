class_name Item
extends Resource

@export var name: String
@export var type: String
@export var stats: Dictionary

func _init(_name: String = "", _type: String = "", _stats: Dictionary = {}):
	name = _name
	type = _type
	stats = _stats
