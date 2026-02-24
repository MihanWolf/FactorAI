# Scripts/test_items.gd
extends Node

@export var item_database: ItemDatabase
@export var component_database: ComponentDatabase

func _ready() -> void:
	if item_database == null or component_database == null:
		push_error("Назначь ItemDatabase и ComponentDatabase в инспекторе!")
		return

	var pool = component_database.build_pool()

	# Генерируем 3 случайных предмета и выводим в консоль
	for i in 3:
		var data = item_database.items.pick_random()
		var inst = ItemInstance.create_random(data, pool)
		_print_item(inst)

func _print_item(inst: ItemInstance) -> void:
	print("=============================")
	print("Предмет: ", inst.data.item_name)
	print("Качество: ", inst.quality)
	print("Рабочий: ", inst.is_functional())
	print("Компоненты:")
	for slot_id in inst.components:
		var comp = inst.components[slot_id]
		if comp == null:
			print("  [", slot_id, "] — пусто")
		else:
			print("  [", slot_id, "] ", comp.data.component_name, 
				" | состояние: ", comp.get_condition_label(),
				" | цвета: ", comp.color_overrides)
