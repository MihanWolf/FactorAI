extends Node

# Основное хранилище предметов игрока.
var storage: Storage = Storage.new()

# Отдельный слот для активного инструмента.
# Живёт вне storage — у него особая роль в системе разборки.
var tool_slot: InventorySlot = InventorySlot.new()


func _ready() -> void:
	storage.storage_name = "Инвентарь"

	for i in 2:
		var slot := InventorySlot.new()
		slot.accepted_type = ItemData.ItemType.ITEM
		storage.slots.append(slot)

	tool_slot.accepted_type = ItemData.ItemType.TOOL


func add_item(item: ItemInstance) -> bool:
	return storage.add_item(item)


# Возвращает ComponentInstance активного инструмента, или null если инструмента нет.
# DisassemblySystem использует это для проверки — можно ли снять компонент.
func get_active_tool() -> ItemInstance:
	return tool_slot.item
