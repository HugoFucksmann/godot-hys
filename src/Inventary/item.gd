class_name Item
extends Resource

var name: String
var type: String
var stats: Dictionary
var scene_path: String  # Nuevo: path a la escena del ítem

func _init(_name: String, _type: String, _stats: Dictionary, _scene_path: String = ""):
	name = _name
	type = _type
	stats = _stats
	scene_path = _scene_path

func instantiate_scene() -> Node:
	if scene_path:
		return load(scene_path).instantiate()
	return null
