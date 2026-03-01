class_name BaseConveyor
extends Node2D

# Сигналы — единственный способ общения с внешним миром
signal item_spawned(instance: ItemInstance)
signal item_cleared

# Сцена предмета в мире — одна для всех конвейеров
const ITEM_SCENE: PackedScene = preload("res://Scenes/item.tscn")

var current_item: Node2D = null
var current_instance: ItemInstance = null

@onready var interaction_zone: InteractionZone = $Interaction_zone


func _ready() -> void:
	interaction_zone.player_interacted.connect(_on_player_interacted)
	interaction_zone.player_exited.connect(_on_player_exited)
	spawn_item()


# ---- Публичный API ----

func spawn_item() -> void:
	_clear_current_item()

	current_instance = _create_item_instance()
	if current_instance == null:
		push_error(name + ": _create_item_instance() вернул null")
		return

	current_item = ITEM_SCENE.instantiate()
	current_item.item_instance = current_instance
	current_item.position = global_position
	get_tree().current_scene.add_child(current_item)
	current_item.item_removed.connect(spawn_item)

	item_spawned.emit(current_instance)


func clear_item() -> void:
	_clear_current_item()
	item_cleared.emit()


# ---- Переопределяй в наследниках ----

# Каждый конвейер сам решает как создать предмет
func _create_item_instance() -> ItemInstance:
	push_error(name + ": _create_item_instance() не переопределён!")
	return null


# ---- Сигналы зоны — базовое поведение ----

func _on_player_interacted() -> void:
	pass	# наследники могут расширить


func _on_player_exited() -> void:
	pass	# наследники могут расширить


# ---- Приватное ----

func _clear_current_item() -> void:
	if current_item and is_instance_valid(current_item):
		current_item.item_removed.disconnect(spawn_item)
		current_item.queue_free()
		current_item = null
	current_instance = null
