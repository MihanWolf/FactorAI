# Scripts/Item/component_database.gd
class_name ComponentDatabase
extends Resource

@export var components: Array[ComponentData] = []

# Возвращает словарь ComponentType → Array[ComponentData]
# Удобно передавать в create_random
func build_pool() -> Dictionary:
	var pool: Dictionary = {}
	for comp in components:
		if not pool.has(comp.component_type):
			pool[comp.component_type] = []
		pool[comp.component_type].append(comp)
	return pool
