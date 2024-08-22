extends Node

var inventory: Array = []
var equipped_items: Dictionary = {
	"weapon": null,
	"armor": null
}

func add_item(item: GlobalItem) -> void:
	inventory.append(item)

func remove_item(item: GlobalItem) -> void:
	inventory.erase(item)

func equip_item(item: GlobalItem, character: GlobalCharacter) -> void:
	if item is GlobalWeapon:
		if equipped_items["weapon"]:
			unequip_item(equipped_items["weapon"], character)
		equipped_items["weapon"] = item
		item.equip(character)
	

func unequip_item(item: GlobalItem, character: GlobalCharacter) -> void:
	# Implementa la lógica para desequipar un ítem
	pass

func use_item(item: GlobalItem, character: GlobalCharacter) -> void:
	item.use(character)
	if item.is_consumable():
		remove_item(item)
