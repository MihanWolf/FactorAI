class_name ItemData
extends Resource

@export var item_name: String
@export var disc: String
@export var q: Array[String] = ["Старый", "Поношенный", "Новый", "Безупречный"]
@export var group: String
@export var count: int
@export var sprite: Texture2D
@export var disassemble_materials: Array[DisassembleEntry] = []
@export var item_type: ItemData.ItemType = ItemData.ItemType.ITEM

enum ItemType {
	MATERIAL,
	ITEM,
	CONSUMABLE,
	EQUIP,
	
}
