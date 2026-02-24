# Scripts/Item/component_instance.gd
class_name ComponentInstance
extends Resource

var data: ComponentData
var condition: float = 1.0        # 0.0 — сломан, 1.0 — идеален
var color_overrides: Dictionary = {}  # { "region_name": Color }
var custom_label: String = ""     # например "Советский динамик"

# Состояние для механики
var is_locked: bool = false       # прикручен болтами — сначала надо открутить
var required_tool: String = ""    # "screwdriver", "soldering_iron"

static func create_random(from_data: ComponentData) -> ComponentInstance:
	var inst = ComponentInstance.new()
	inst.data = from_data
	inst.condition = randf_range(0.2, 1.0)
	# Генерируем случайный цвет для каждого региона
	for region in from_data.color_regions:
		inst.color_overrides[region] = Color(randf(), randf(), randf())
	return inst

func get_condition_label() -> String:
	if condition >= 0.9: return "Идеальное"
	if condition >= 0.7: return "Хорошее"
	if condition >= 0.4: return "Поношенное"
	return "Сломанное"
