extends Node2D

@onready var _inventory_ui = $CanvasLayer/inventory_ui
@onready var _conveyor = $GarbageConveyor
@onready var _conveyor_ui = $CanvasLayer/ConveyorUI
@onready var _disassembly_table = $DisassemblyTable
@onready var _disassembly_ui = $CanvasLayer/DisassemblyUI  # появится на следующем шаге
@onready var _player = $CharacterBody2D


func _ready() -> void:
	PlayerInventory.storage.storage_name = "Инвентарь"
	_inventory_ui.init(PlayerInventory.storage)
	_inventory_ui.hide()

	_conveyor_ui.init(_conveyor)
	_conveyor.start()

	# Подписываемся на сигналы стола.
	# UI будет создан на следующем шаге — пока просто замораживаем игрока.
	_disassembly_table.table_opened.connect(_on_table_opened)
	_disassembly_table.table_closed.connect(_on_table_closed)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		_inventory_ui.visible = not _inventory_ui.visible


func _on_table_opened(table: DisassemblyTable) -> void:
	_player.freeze()
	# _disassembly_ui.init(table)  <- раскомментируй на шаге 4
	# _disassembly_ui.show()


func _on_table_closed() -> void:
	_player.unfreeze()
	# _disassembly_ui.hide()
