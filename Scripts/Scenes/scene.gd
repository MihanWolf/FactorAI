extends Node2D

@onready var inventory_ui = $CanvasLayer/inventory_ui
@onready var conveyor = $GarbageConveyor
@onready var conveyor_ui = $CanvasLayer/ConveyorUI

func _ready() -> void:
	PlayerInventory.storage.storage_name = "Инвентарь"
	inventory_ui.init(PlayerInventory.storage)
	inventory_ui.hide()
	
	conveyor_ui.init(conveyor)
	conveyor.start()  # ← запускаем конвейер только после того как UI подписался

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		inventory_ui.visible = not inventory_ui.visible
