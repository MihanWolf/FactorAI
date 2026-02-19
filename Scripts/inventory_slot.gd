class_name InventorySlot
extends Resource

@export var accepted_type: ItemData.ItemType = ItemData.ItemType.ITEM
var item: ItemInstance = null

func can_accept(incoming: ItemInstance) -> bool:
	if accepted_type == ItemData.ItemType.ITEM:
		return true
	return incoming.data.item_type == accepted_type

func place_item(incoming: ItemInstance) -> bool:
	if item != null:
		return false  # слот занят
	if not can_accept(incoming):
		return false  # неподходящий тип
	item = incoming
	return true

func remove_item() -> ItemInstance:
	var removed = item
	item = null
	return removed
