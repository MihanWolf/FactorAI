extends Node

var storage: Storage = Storage.new()


func _ready():
	for i in 2:
		var slot = InventorySlot.new()
		slot.accepted_type = ItemData.ItemType.ITEM
		storage.slots.append(slot)


func add_item(item: ItemInstance) -> bool:
	return storage.add_item(item)
	
