class_name ConveyorUI
extends CanvasLayer

const GARBAGE_UI_SCENE: PackedScene = preload("res://Scenes/UI/garbage_ui.tscn")

# Ссылка на конвейер — назначается при инициализации
var _conveyor: BaseConveyor = null
var _garbage_ui: GarbageUI = null


func init(conveyor: BaseConveyor) -> void:
	_conveyor = conveyor
	_conveyor = conveyor
	_conveyor.item_spawned.connect(_on_item_spawned)
	_conveyor.item_cleared.connect(_on_item_cleared)
	_conveyor.interaction_zone.player_exited.connect(_on_player_exited)
	_conveyor.interaction_zone.player_entered.connect(_on_player_entered)
	_conveyor.interaction_zone.player_interacted.connect(_on_player_interacted)

	_garbage_ui = GARBAGE_UI_SCENE.instantiate()
	add_child(_garbage_ui)
	_garbage_ui.burn_pressed.connect(_on_burn_pressed)
	_garbage_ui.take_pressed.connect(_on_take_pressed)
	_garbage_ui.send_to_cart_pressed.connect(_on_send_to_cart_pressed)
	_garbage_ui.hide()


# ---- Реакция на конвейер ----

func _on_item_spawned(instance: ItemInstance) -> void:
	if _garbage_ui.visible:
		_garbage_ui.show_item(instance)


func _on_item_cleared() -> void:
	pass


# ---- Реакция на зону ----

func _on_player_entered() -> void:
	pass

#	if _conveyor.current_instance != null:
#		_garbage_ui.show_item(_conveyor.current_instance)
#		_garbage_ui.show()


func _on_player_exited() -> void:
	_garbage_ui.hide()
	for cart in _conveyor.get_carts_in_range():
		cart.inventory_ui.hide()

# ---- Кнопки GarbageUI ----

func _on_burn_pressed() -> void:
	_conveyor.burn()


func _on_take_pressed() -> void:
	_conveyor.take()
	
func _on_send_to_cart_pressed() -> void:
	for cart in _conveyor.get_carts_in_range():
		if _conveyor.send_to_storage(cart.storage):
			print("Отправлено в телегу")
			return
	print("Телега не найдена рядом")
	
func _on_player_interacted() -> void:
	if _garbage_ui.visible:
		_garbage_ui.hide()
		for cart in _conveyor.get_carts_in_range():
			cart.inventory_ui.hide()
	elif _conveyor.current_instance != null:
		_garbage_ui.show_item(_conveyor.current_instance)
		_garbage_ui.show()
		for cart in _conveyor.get_carts_in_range():
			cart.inventory_ui.show()
