# Scenes/item.gd
extends Node2D

var item_instance: ItemInstance

signal item_removed

func _ready():
	$Sprite2D.texture = item_instance.data.sprite
	$Sprite2D.scale = Vector2(0.1, 0.1)
