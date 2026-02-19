extends Node2D

var item_instance: ItemInstance

signal item_removed

func _ready():
	$Sprite2D.texture = item_instance.data.sprite
	$Sprite2D.scale = Vector2(0.1, 0.1)
	
func burn():
	item_removed.emit()
	queue_free()
	
func disassemble():
	
	var quality_multiplier = 1.0
	match item_instance.quality:
		"Старый": quality_multiplier = 0.5
		"Поношенный": quality_multiplier = 0.75
		"Новый": quality_multiplier = 1.0
		"Безупречный": quality_multiplier = 1.5
	for entry in item_instance.data.disassemble_materials:
		var base_count = randi_range(entry.count_min, entry.count_max)
		var final_count = max(1, int(base_count * quality_multiplier))
		if final_count > 0:
			print(entry.material.material_name, " x", final_count)
			# Позже тут будет спавн или добавление в инвентарь
	# тут пропишем логику спавна материалов
	
	item_removed.emit()
	queue_free()

func take():
	# тут будет логика перемещения предмета в инвентарь
	PlayerInventory.add_item(item_instance)
	item_removed.emit()
	queue_free()
	
func send_to_storage(target_storage: Storage):
	if target_storage.add_item(item_instance):
		item_removed.emit()
		queue_free()
	else:
		print("Хранилище полно")
