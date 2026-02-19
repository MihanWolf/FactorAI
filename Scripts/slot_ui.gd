extends Panel

@onready var icon = $TextureRect
@onready var label = $Label

func update(slot: InventorySlot):
	if slot.item == null:
		icon.texture = null
		label.text = "Пусто"
	else:
		icon.texture = slot.item.data.sprite
		label.text = slot.item.data.item_name
