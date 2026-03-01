extends Node2D

@onready var inventory_ui = $CanvasLayer/inventory_ui


func _ready() -> void:
	PlayerInventory.storage.storage_name = "Инвентарь"
	inventory_ui.init(PlayerInventory.storage)
	inventory_ui.hide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		inventory_ui.visible = not inventory_ui.visible
