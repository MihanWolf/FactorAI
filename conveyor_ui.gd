class_name ConveyorUI
extends CanvasLayer

const GARBAGE_UI_SCENE: PackedScene = preload("res://Scenes/UI/garbage_ui.tscn")
const DISASSEMBLY_UI_SCENE: PackedScene = preload("res://Scenes/UI/disasseble_ui.tscn")

# Ссылка на конвейер — назначается при инициализации
var _conveyor: BaseConveyor = null

var _garbage_ui: GarbageUI = null
var _disassembly_ui: DisassemblyUI = null


func init(conveyor: BaseConveyor) -> void:
	_conveyor = conveyor
	_conveyor.item_spawned.connect(_on_item_spawned)
	_conveyor.item_cleared.connect(_on_item_cleared)
	_conveyor.interaction_zone.player_exited.connect(_on_player_exited)
	_conveyor.interaction_zone.player_entered.connect(_on_player_entered)

	_garbage_ui = GARBAGE_UI_SCENE.instantiate()
	add_child(_garbage_ui)
	_garbage_ui.burn_pressed.connect(_on_burn_pressed)
	_garbage_ui.take_pressed.connect(_on_take_pressed)
	_garbage_ui.disassemble_pressed.connect(_on_disassemble_pressed)
	_garbage_ui.hide()


# ---- Реакция на конвейер ----

func _on_item_spawned(instance: ItemInstance) -> void:
	_close_disassembly_ui()
	if _conveyor.interaction_zone.player_inside:
		_garbage_ui.show_item(instance)
		_garbage_ui.show()


func _on_item_cleared() -> void:
	_garbage_ui.hide()
	_close_disassembly_ui()


# ---- Реакция на зону ----

func _on_player_entered() -> void:
	if _conveyor.current_instance != null:
		_garbage_ui.show_item(_conveyor.current_instance)
		_garbage_ui.show()


func _on_player_exited() -> void:
	_garbage_ui.hide()
	_close_disassembly_ui()


# ---- Кнопки GarbageUI ----

func _on_burn_pressed() -> void:
	if _conveyor.current_item:
		_conveyor.current_item.burn()


func _on_take_pressed() -> void:
	if _conveyor.current_item:
		_conveyor.current_item.take()


func _on_disassemble_pressed() -> void:
	_close_disassembly_ui()
	_garbage_ui.hide()

	_disassembly_ui = DISASSEMBLY_UI_SCENE.instantiate()
	add_child(_disassembly_ui)
	if not _disassembly_ui.is_node_ready():
		await _disassembly_ui.ready

	_disassembly_ui.init(_conveyor.current_instance, [])


# ---- Утилиты ----

func _close_disassembly_ui() -> void:
	if _disassembly_ui and is_instance_valid(_disassembly_ui):
		_disassembly_ui.queue_free()
		_disassembly_ui = null
