@tool
extends Button

@export_file("*.tscn") var next_scene_path: String = ""

func _on_button_up():
	get_tree().change_scene_to_file(next_scene_path)


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if next_scene_path.is_empty():
		warnings.append("next_scene_path must be set")
	return warnings
