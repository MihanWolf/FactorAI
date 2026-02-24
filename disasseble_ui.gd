# Scripts/UI/disassembly_ui.gd
class_name DisassemblyUI
extends Control

signal component_removed(slot_id: String, component: ComponentInstance)
signal component_placed(slot_id: String, component: ComponentInstance)

@onready var item_view = $ItemView
@onready var slot_list = $SlotList
@onready var component_info = $ComponentInfo

var item_instance: ItemInstance
var selected_slot_id: String = ""
var player_tools: Array[String] = []  # инструменты у игрока

func init(instance: ItemInstance, tools: Array[String]) -> void:
	item_instance = instance
	player_tools = tools
	_rebuild_ui()
	item_instance.component_changed.connect(_on_component_changed)

func _rebuild_ui() -> void:
	item_view.display(item_instance)
	_rebuild_slot_list()

func _rebuild_slot_list() -> void:
	for child in slot_list.get_children():
		child.queue_free()
	
	for slot in item_instance.data.component_slots:
		var row = SlotRow.new()  # отдельная сцена
		row.init(slot, item_instance.components.get(slot.slot_id))
		row.slot_selected.connect(_on_slot_selected)
		slot_list.add_child(row)

func _on_slot_selected(slot_id: String) -> void:
	selected_slot_id = slot_id
	var comp = item_instance.components.get(slot_id)
	component_info.display(comp, _can_remove(slot_id))

func _can_remove(slot_id: String) -> bool:
	var slot = item_instance._get_slot(slot_id)
	if slot == null: return false
	# Проверяем есть ли нужный инструмент
	if slot.get("required_tool") != "":
		return player_tools.has(slot.required_tool)
	return true

func _on_remove_pressed() -> void:
	if selected_slot_id == "":
		return
	var comp = item_instance.remove_component(selected_slot_id)
	if comp:
		component_removed.emit(selected_slot_id, comp)

func _on_component_changed(slot_id: String) -> void:
	_rebuild_slot_list()
	if slot_id == selected_slot_id:
		var comp = item_instance.components.get(slot_id)
		component_info.display(comp, _can_remove(slot_id))
