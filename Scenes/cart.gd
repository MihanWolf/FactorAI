class_name Cart
extends Node2D

signal picked_up(cart)
signal dropped(cart)

@export var storage_slots: int = 6

var storage: Storage = Storage.new()
var is_carried: bool = false
var player_in_range: bool = false

@onready var static_body = $StaticBody2D
@onready var collision_shape = $StaticBody2D/CollisionShape2D 
@onready var interaction_zone = $Interaction_zone
@onready var inventory_ui = $inventory_ui

func _ready():
	add_to_group("cart")
	storage.storage_name = "Телега"
	for i in storage_slots:
		var slot = InventorySlot.new()
		slot.accepted_type = ItemData.ItemType.ITEM
		storage.slots.append(slot)
		
	inventory_ui.init(storage)
	inventory_ui.hide()
	
	interaction_zone.body_entered.connect(_on_player_entered)
	interaction_zone.body_exited.connect(_on_player_exited)
	interaction_zone.player_interacted.connect(_on_interact)

func _on_interact():
	inventory_ui.visible = not inventory_ui.visible

func _on_player_entered(body):
	if body.is_in_group("player"):
		player_in_range = true

func _on_player_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		inventory_ui.hide()

func pickup():
	is_carried = true
	static_body.set_deferred("disabled", true)  # выключаем коллизию
	picked_up.emit(self)

func drop(world_position: Vector2):
	is_carried = false
	# Reparent обратно в мир
	var world = get_tree().current_scene
	var global = global_position
	reparent(world)
	global_position = world_position
	static_body.set_deferred("disabled", false)
	dropped.emit(self)
