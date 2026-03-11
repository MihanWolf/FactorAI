class_name DisassemblyTable
extends Node2D

# ---- Сигналы ----

# Игрок нажал E у стола — UI должен открыться
signal table_opened(table: DisassemblyTable)

# Игрок отошёл или закрыл UI
signal table_closed

# Список Storage рядом изменился (телега подъехала или уехала)
signal nearby_storages_changed(storages: Array)


# ---- Константы ----

const ITEMS_SLOT_COUNT: int = 6
const COMPONENTS_SLOT_COUNT: int = 12


# ---- Переменные ----

# Предметы которые лежат на столе
var items_storage: Storage = Storage.new()

# Снятые компоненты (ItemInstance-обёртки с item_type = COMPONENT)
var components_storage: Storage = Storage.new()

# Storage всех объектов в зоне стола. Ключ — нода-владелец, значение — её Storage.
var _nearby_storages: Dictionary = {}


# ---- Ноды ----

@onready var _interaction_zone: InteractionZone = $Interaction_zone
@onready var _nearby_zone: Area2D = $NearbyZone


# ---- Жизненный цикл ----

func _ready() -> void:
	_setup_storages()
	_interaction_zone.player_interacted.connect(_on_player_interacted)
	_interaction_zone.player_exited.connect(_on_player_exited)
	_nearby_zone.body_entered.connect(_on_nearby_body_entered)
	_nearby_zone.body_exited.connect(_on_nearby_body_exited)
	_nearby_zone.area_entered.connect(_on_nearby_area_entered)
	_nearby_zone.area_exited.connect(_on_nearby_area_exited)


# ---- Публичные методы ----

# Возвращает массив всех Storage в радиусе стола.
# UI вызывает это при открытии чтобы отрисовать панели источников.
func get_nearby_storages() -> Array:
	return _nearby_storages.values()


# ---- Приватные методы ----

func _setup_storages() -> void:
	items_storage.storage_name = "Стол"
	for i in ITEMS_SLOT_COUNT:
		var slot := InventorySlot.new()
		slot.accepted_type = ItemData.ItemType.ITEM
		items_storage.slots.append(slot)

	components_storage.storage_name = "Компоненты"
	for i in COMPONENTS_SLOT_COUNT:
		var slot := InventorySlot.new()
		slot.accepted_type = ItemData.ItemType.COMPONENT
		components_storage.slots.append(slot)


# Пытается зарегистрировать ноду как источник Storage рядом со столом.
# Duck typing — работает с любой нодой у которой есть поле storage,
# без привязки к конкретному классу (Cart, Box, и любые будущие).
func _try_register_storage(node: Object) -> void:
	if node == null:
		return
	if not "storage" in node:
		return
	if node in _nearby_storages:
		return
	_nearby_storages[node] = node.storage
	nearby_storages_changed.emit(_nearby_storages.values())


func _try_unregister_storage(node: Object) -> void:
	if node == null:
		return
	if not node in _nearby_storages:
		return
	_nearby_storages.erase(node)
	nearby_storages_changed.emit(_nearby_storages.values())


# ---- Обработчики сигналов ----

func _on_player_interacted() -> void:
	table_opened.emit(self)


func _on_player_exited() -> void:
	table_closed.emit()


func _on_nearby_body_entered(body: Node2D) -> void:
	_try_register_storage(body)


func _on_nearby_body_exited(body: Node2D) -> void:
	_try_unregister_storage(body)


# Area2D тоже проверяем — Storage может висеть на родителе Area2D
func _on_nearby_area_entered(area: Area2D) -> void:
	_try_register_storage(area.get_parent())


func _on_nearby_area_exited(area: Area2D) -> void:
	_try_unregister_storage(area.get_parent())
