class_name GarbageConveyor
extends BaseConveyor

@export var item_database: ItemDatabase
@export var component_database: ComponentDatabase


func _ready() -> void:
	if item_database == null or component_database == null:
		push_error(name + ": назначь ItemDatabase и ComponentDatabase!")
		return

func start() -> void:
	super._ready()

func _create_item_instance() -> ItemInstance:
	var pool := component_database.build_pool()
	var data: ItemData = item_database.items.pick_random()
	return ItemInstance.create_random(data, pool)


func burn() -> void:
	if current_instance == null:
		return
	_on_item_processed()


func take() -> bool:
	if current_instance == null:
		return false
	if PlayerInventory.storage.is_full():
		print("Инвентарь полон")
		return false
	PlayerInventory.add_item(current_instance)
	_on_item_processed()
	return true


func send_to_storage(target_storage: Storage) -> bool:
	if current_instance == null:
		return false
	if target_storage.add_item(current_instance):
		_on_item_processed()
		return true
	print("Хранилище полно")
	return false
