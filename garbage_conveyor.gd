class_name GarbageConveyor
extends BaseConveyor

# Только эти два ресурса нужны конкретно этому конвейеру
@export var item_database: ItemDatabase
@export var component_database: ComponentDatabase


func _ready() -> void:
	if item_database == null or component_database == null:
		push_error(name + ": назначь ItemDatabase и ComponentDatabase в инспекторе!")
		return
	super._ready()	# вызываем _ready() базового класса, который запустит spawn_item()


# Переопределяем единственный метод — как создать предмет
func _create_item_instance() -> ItemInstance:
	var pool := component_database.build_pool()
	var data: ItemData = item_database.items.pick_random()
	return ItemInstance.create_random(data, pool)
