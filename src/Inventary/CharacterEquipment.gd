extends Node

signal item_equipped(item: Item, slot: String)
signal item_unequipped(item: Item, slot: String)
signal stats_updated(new_stats: Dictionary)

var equipment = {
	"arma": null,
	"guantes": null,
	"botas": null,
	"armadura": null,
	"casco": null,
	"accesorio": null
}

var base_stats = {
	"ataque": 10,
	"defensa": 5,
	"velocidad": 3
}

func equip_item(item: Item) -> bool:
	if item.type in equipment:
		if equipment[item.type]:
			unequip_item(item.type)
		
		equipment[item.type] = item
		emit_signal("item_equipped", item, item.type)
		update_stats()
		# Instanciar la escena del ítem y añadirla al personaje
		var item_instance = item.instantiate_scene()
		if item_instance:
			add_child(item_instance)

		return true
	return false

func unequip_item(slot: String) -> Item:
	if slot in equipment and equipment[slot]:
		var item = equipment[slot]
		equipment[slot] = null
		emit_signal("item_unequipped", item, slot)
		update_stats()
		var item_instance = get_node_or_null(item.name)
		if item_instance:
			remove_child(item_instance)
			item_instance.queue_free()
		return item
	return null

func update_stats():
	var total_stats = base_stats.duplicate()
	
	for item in equipment.values():
		if item:
			for stat in item.stats:
				total_stats[stat] += item.stats[stat]
	
	emit_signal("stats_updated", total_stats)
