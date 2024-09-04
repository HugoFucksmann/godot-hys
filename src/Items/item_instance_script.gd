extends Node2D

var item: GlobalItem

func setup(p_item: GlobalItem):
	item = p_item
	$Sprite2D.texture = item.icon
	$CollisionShape2D.shape.radius = item.get_stat("pickup_radius")

func _on_body_entered(body):
	if body.has_method("pickup_item"):
		body.pickup_item(item)
		queue_free()
