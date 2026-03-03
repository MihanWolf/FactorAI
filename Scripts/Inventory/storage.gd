class_name Storage
extends Resource

@export var storage_name: String = ""
@export var slots: Array[InventorySlot] = []

signal slot_changed(slot_index: int)

func add_item(item: ItemInstance) -> bool:
	for i in slots.size():
		if slots[i].place_item(item):
			slot_changed.emit(i)
			return true
	return false  # нет подходящего слота

func remove_item_from_slot(index: int) -> ItemInstance:
	var item = slots[index].remove_item()
	if item:
		slot_changed.emit(index)
	return item

func is_full() -> bool:
	for slot in slots:
		if slot.item == null:
			return false
	return true
