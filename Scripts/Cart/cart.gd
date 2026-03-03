class_name Cart
extends Node2D

signal picked_up
signal dropped

@export var storage_slots: int = 6

var storage: Storage = Storage.new()
var is_carried: bool = false

@onready var static_body = $StaticBody2D
@onready var collision_shape = $StaticBody2D/CollisionShape2D
@onready var interaction_zone = $Interaction_zone
@onready var inventory_ui = $inventory_ui

var _ui_size: Vector2 = Vector2.ZERO

func _ready():
	add_to_group("cart")
	storage.storage_name = "Телега"
	for i in storage_slots:
		var slot = InventorySlot.new()
		slot.accepted_type = ItemData.ItemType.ITEM
		storage.slots.append(slot)

	inventory_ui.init(storage)
	inventory_ui.show()
	await get_tree().process_frame
	_ui_size = inventory_ui.size
	print("ui size: ", _ui_size)

	inventory_ui.init(storage)
	inventory_ui.hide()
	
	interaction_zone.player_interacted.connect(_on_interact)
	interaction_zone.player_entered.connect(_on_player_entered)
	interaction_zone.player_exited.connect(_on_player_exited)



func _on_interact():
	if inventory_ui.visible:
		inventory_ui.hide()
	else:
		_show_inventory_ui()

func _on_player_entered():
	pass

func _on_player_exited():
	inventory_ui.hide()

func _show_inventory_ui() -> void:
	inventory_ui.show()
	await get_tree().process_frame
	

func pickup():
	is_carried = true
	collision_shape.set_deferred("disabled", true)
	picked_up.emit()

func drop(world_position: Vector2):
	is_carried = false
	var world = get_tree().current_scene
	reparent(world)
	global_position = world_position
	collision_shape.set_deferred("disabled", false)
	dropped.emit()
