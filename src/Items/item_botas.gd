extends BaseEquippableItem
class_name BootsItem

func apply_stats():
	if item_data:
		StatsManager.add_stats(item_data.stats)
