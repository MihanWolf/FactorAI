class_name ItemData
extends Resource

@export var item_name: String
@export var description: String
@export var quality_levels: Array[String] = ["Старый", "Поношенный", "Новый", "Безупречный"]
@export var component_slots: Array[ComponentSlotData] = []
@export var tags: Array[String] = [] 
@export var sprite: Texture2D
@export var disassemble_materials: Array[DisassembleEntry] = []
@export var item_type: ItemData.ItemType = ItemData.ItemType.ITEM

enum ItemType {
	ANY,
	MATERIAL,
	ITEM,
	CONSUMABLE,
	EQUIP,
	TOOL,
	COMPONENT,
	
}
