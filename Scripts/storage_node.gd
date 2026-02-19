extends Node2D

var storage: Storage = Storage.new()
@export var slot_count: int = 6

func _ready():
	for i in slot_count:
		var slot = InventorySlot.new()
		slot.accepted_type = ItemData.ItemType.ITEM
		storage.slots.append(slot)
