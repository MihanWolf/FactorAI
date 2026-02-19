extends Node2D

var item_scene: PackedScene = preload("res://Scenes/item.tscn")
var item_database: ItemDatabase = preload("res://Resources/ItemDatabase.tres")
var item_ui_scene: PackedScene = preload("res://Scenes/UI/garbage_ui.tscn")
var current_item: Node2D = null
var current_ui: CanvasLayer = null

@onready var inventory_ui = $inventory_ui
@onready var item_zone: InteractionZone = $Interaction_zone

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		inventory_ui.visible = not inventory_ui.visible

func _ready() -> void:
	PlayerInventory.storage.storage_name = "Инвентарь"
	item_zone.area_entered.connect(_on_area_entered_item_zone)
	item_zone.area_exited.connect(_on_area_exited_item_zone)
	inventory_ui.init(PlayerInventory.storage)
	inventory_ui.hide()
	
	item_zone.player_interacted.connect(func():
		if current_ui:
			current_ui.show()
		var cart = _get_cart_in_zone()
		if cart:
			cart.inventory_ui.show()
	)
	item_zone.player_exited.connect(func():
		if current_ui:
			current_ui.hide()
		var cart = _get_cart_in_zone()
		if cart:
			cart.inventory_ui.hide()
	)
	item_zone.player_entered.connect(func():
		var cart = _get_cart_in_zone()
		if cart:
			cart.inventory_ui.show()
	)
	item_zone.player_exited.connect(func():
		var cart = _get_cart_in_zone()
		if cart:
			cart.inventory_ui.hide()
)
	
	spawn_item()

func _get_cart_in_zone() -> Cart:
	for area in item_zone.get_overlapping_areas():
		if area.get_parent() is Cart:
			return area.get_parent()
	return null
	
func _on_area_entered_item_zone(area: Area2D):
	print("area entered: ", area.name, " parent: ", area.get_parent().name)
	var cart = area.get_parent()
	if cart is Cart and item_zone.player_inside:
		cart.inventory_ui.show()

func _on_area_exited_item_zone(area: Area2D):
	var cart = area.get_parent()
	if cart is Cart:
		cart.inventory_ui.hide()

func spawn_item():
	if current_ui:
		current_ui.queue_free()
	if current_item:
		current_item.queue_free()
	
	var data = item_database.items.pick_random()
	var instance = ItemInstance.create_random(data)
	
	current_item = item_scene.instantiate()
	current_item.item_instance = instance
	current_item.position = get_viewport().get_visible_rect().size / 2
	add_child(current_item)
	
	current_ui = item_ui_scene.instantiate()
	add_child(current_ui)
	current_ui.show_item(instance)
	
	if item_zone.player_inside:
		current_ui.show()
	else:
		current_ui.hide()
	
	current_ui.burn_pressed.connect(current_item.burn)
	current_ui.take_pressed.connect(current_item.take)
	current_ui.recycle_pressed.connect(_on_recycle_pressed)
	
	current_item.item_removed.connect(spawn_item)

func _on_recycle_pressed():
	# Ищем телегу в сцене и кладём туда
	var cart = get_tree().get_first_node_in_group("cart")
	if cart:
		current_item.send_to_storage(cart.storage)
