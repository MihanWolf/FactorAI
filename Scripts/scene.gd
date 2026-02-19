extends Node2D

var item_scene: PackedScene = preload("res://Scenes/item.tscn")
var item_database: ItemDatabase = preload("res://Resources/ItemDatabase.tres")
var item_ui_scene: PackedScene = preload("res://Scenes/UI/garbage_ui.tscn")
var current_item: Node2D = null
var current_ui: CanvasLayer = null

@onready var storage_ui = $Cart/inventory_ui
@onready var storage_node = $Cart
@onready var inventory_ui = $inventory_ui
@onready var item_zone: InteractionZone = $Interaction_zone
@onready var telega_zone: InteractionZone = $Cart/Interaction_zone

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_focus_next"):
		if inventory_ui.visible:
			inventory_ui.hide()
		else:
			inventory_ui.show()

func _ready() -> void:
	PlayerInventory.storage.storage_name = "Инвентарь"
	storage_node.storage.storage_name = "Телега"
	
	inventory_ui.init(PlayerInventory.storage)
	storage_ui.init(storage_node.storage)
	inventory_ui.hide()
	storage_ui.hide()
		
	telega_zone.player_interacted.connect(func():
		storage_ui.show()
	)
	telega_zone.player_exited.connect(func():
		storage_ui.hide()
	)
	
	item_zone.player_interacted.connect(func():
		if current_ui:
			current_ui.show()
		# если телега в радиусе item_zone — показываем и её
		if _is_storage_in_item_zone():
			storage_ui.show()
	)
	item_zone.player_exited.connect(func():
		if current_ui:
			current_ui.hide()
		# скрываем UI телеги только если игрок вышел и из storage_zone тоже
		if not telega_zone.player_inside:
			storage_ui.hide()
	)
	
	spawn_item()
	
	
	
	
func _is_storage_in_item_zone() -> bool:
	var bodies = item_zone.get_overlapping_bodies()
	for body in bodies:
		if body.get_parent() == storage_node:
			return true
	return false
	
	
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
	#current_ui.disassemble_pressed.connect(current_item.disassemble)
	current_ui.take_pressed.connect(current_item.take)
	current_ui.recycle_pressed.connect(_on_recycle_pressed)  # отдельная кнопка переработки
	
	current_item.item_removed.connect(spawn_item)

func _on_recycle_pressed():
	current_item.send_to_storage(storage_node.storage)
