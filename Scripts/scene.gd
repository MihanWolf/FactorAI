extends Node2D

var item_scene: PackedScene = preload("res://Scenes/item.tscn")
var item_database: ItemDatabase = preload("res://Resources/ItemDatabase.tres")
var item_ui_scene: PackedScene = preload("res://Scenes/UI/garbage_ui.tscn")
var current_item: Node2D = null
var current_ui: CanvasLayer = null

@onready var storage_ui = $Node2D/inventory_ui
@onready var storage_node = $Node2D
@onready var inventory_ui = $inventory_ui

func _ready() -> void:
	PlayerInventory.storage.storage_name = "Инвентарь"
	storage_node.storage.storage_name = "Телега"
	
	inventory_ui.init(PlayerInventory.storage)
	storage_ui.init(storage_node.storage)
	spawn_item()
	
func spawn_item():
	if current_ui:
		current_ui.queue_free()
	
	var data = item_database.items.pick_random()
	var instance = ItemInstance.create_random(data)
	
	current_item = item_scene.instantiate()
	current_item.item_instance = instance
	current_item.position = get_viewport().get_visible_rect().size / 2
	add_child(current_item)
	
	current_ui = item_ui_scene.instantiate()
	add_child(current_ui)
	current_ui.show_item(instance)
	
	current_ui.burn_pressed.connect(current_item.burn)
	#current_ui.disassemble_pressed.connect(current_item.disassemble)
	current_ui.take_pressed.connect(current_item.take)
	current_ui.recycle_pressed.connect(_on_recycle_pressed)  # отдельная кнопка переработки
	
	current_item.item_removed.connect(spawn_item)

func _on_recycle_pressed():
	current_item.send_to_storage(storage_node.storage)
