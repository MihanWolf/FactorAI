extends Node2D

var item_instance: ItemInstance


func _ready():
	$Sprite2D.texture = item_instance.data.sprite
	$Sprite2D.scale = Vector2(0.1, 0.1)
