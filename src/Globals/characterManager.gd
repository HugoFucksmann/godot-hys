extends Node

var characters: Dictionary = {}

func _ready() -> void:
	load_characters()

func load_characters() -> void:
	var character_data = load_character_data()
	for char_name in character_data:
		var char_stats = character_data[char_name]
		var new_char = GlobalCharacter.new()
		new_char.name = char_name
		apply_character_stats(new_char, char_stats)
		characters[char_name] = new_char

func load_character_data() -> Dictionary:
	var file = FileAccess.open("res://data/character_data.json", FileAccess.READ)
	if file:
		var json = JSON.parse_string(file.get_as_text())
		file.close()
		if json is Dictionary:
			return json
	return {}

func apply_character_stats(character: GlobalCharacter, stats: Dictionary) -> void:
	for stat in stats:
		if character.has(stat):
			character.set(stat, stats[stat])

func select_character(char_name: String) -> GlobalCharacter:
	if char_name in characters:
		GlobalState.selected_character = char_name
		return characters[char_name]
	return null

func get_selected_character() -> GlobalCharacter:
	return characters[GlobalState.selected_character] if GlobalState.selected_character in characters else null
