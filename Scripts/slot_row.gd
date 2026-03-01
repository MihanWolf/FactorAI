class_name SlotRow
extends HBoxContainer

signal slot_selected(slot_id: String)

var _slot_id: String = ""

@onready var slot_label = $SlotLabel
@onready var component_label = $ComponentLabel
@onready var select_button = $SelectButton

func init(slot: ComponentSlotData, component: ComponentInstance) -> void:
	_slot_id = slot.slot_id
	slot_label.text = slot.slot_label
	
	if component == null:
		component_label.text = "Пусто"
	else:
		component_label.text = component.data.component_name + " | " + component.get_condition_label()
	select_button.pressed.connect(func():
		slot_selected.emit(_slot_id))
