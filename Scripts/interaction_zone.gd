class_name InteractionZone
extends Area2D

@export var ui_scene: PackedScene

signal player_interacted
signal player_entered
signal player_exited

var player_inside: bool = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body is Player:
		player_inside = true
		body.register_zone(self)
		player_entered.emit()

func _on_body_exited(body):
	if body is Player:
		player_inside = false
		body.unregister_zone(self)
		player_exited.emit()

func try_interact():
	if player_inside:
		player_interacted.emit()
