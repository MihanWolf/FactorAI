class_name ConveyorZone
extends Node2D

var item_scene: PackedScene = preload("res://Scenes/item.tscn")
var item_database: ItemDatabase = preload("res://Resources/ItemDatabase.tres")
var item_ui_scene: PackedScene = preload("res://Scenes/UI/garbage_ui.tscn")

var current_item: Node2D = null
var current_ui: CanvasLayer = null
var canvas_layer: CanvasLayer = null

@onready var interaction_zone: InteractionZone = $Interaction_zone

func _ready() -> void:
	interaction_zone.area_entered.connect(_on_area_entered)
	interaction_zone.area_exited.connect(_on_area_exited)
	interaction_zone.player_entered.connect(_on_player_entered)
	interaction_zone.player_interacted.connect(_on_player_interacted)
	interaction_zone.player_exited.connect(_on_player_exited)

# ---- Спавн ----

func spawn_item() -> void:
	if current_ui:
		current_ui.queue_free()
		current_ui = null
	if current_item:
		current_item.queue_free()
		current_item = null

	var data = item_database.items.pick_random()
	var instance = ItemInstance.create_random(data)

	current_item = item_scene.instantiate()
	current_item.item_instance = instance
	current_item.position = get_viewport().get_visible_rect().size / 2
	get_tree().current_scene.add_child(current_item)

	current_ui = item_ui_scene.instantiate()
	canvas_layer.add_child(current_ui)
	if not current_ui.is_node_ready():
		await current_ui.ready

	current_ui.show_item(instance)
	_update_ui_visibility()

	current_ui.burn_pressed.connect(current_item.burn)
	current_ui.take_pressed.connect(current_item.take)
	current_ui.recycle_pressed.connect(_on_recycle_pressed)

	current_item.item_removed.connect(spawn_item)

# ---- Взаимодействие с зоной ----

func _on_player_entered() -> void:
	pass

func _on_player_interacted() -> void:
	_update_ui_visibility()
	var cart = _get_cart_in_zone()
	if cart:
		cart.inventory_ui.show()

func _on_player_exited() -> void:
	_update_ui_visibility()
	var cart = _get_cart_in_zone()
	if cart:
		cart.inventory_ui.hide()

func _on_area_entered(area: Area2D) -> void:
	var cart = area.get_parent()
	if cart is Cart and interaction_zone.player_inside:
		cart.inventory_ui.show()

func _on_area_exited(area: Area2D) -> void:
	var cart = area.get_parent()
	if cart is Cart:
		cart.inventory_ui.hide()

# ---- Вспомогательное ----

func _get_cart_in_zone() -> Cart:
	for area in interaction_zone.get_overlapping_areas():
		if area.get_parent() is Cart:
			return area.get_parent()
	return null

func _on_recycle_pressed() -> void:
	var cart = _get_cart_in_zone()
	if cart:
		current_item.send_to_storage(cart.storage)
	else:
		print("Телега не в зоне")

func _update_ui_visibility() -> void:
	if current_ui == null:
		return
	if interaction_zone.player_inside:
		current_ui.show()
	else:
		current_ui.hide()
