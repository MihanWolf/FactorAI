extends Node2D

@onready var inventory_ui = $CanvasLayer/inventory_ui
@onready var canvas_layer = $CanvasLayer
@onready var conveyor_zone = $Conveyor

func _ready() -> void:
	PlayerInventory.storage.storage_name = "Инвентарь"
	inventory_ui.init(PlayerInventory.storage)
	inventory_ui.hide()
	
	conveyor_zone.canvas_layer = canvas_layer
	conveyor_zone.spawn_item()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		inventory_ui.visible = not inventory_ui.visible
