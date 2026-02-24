class_name ItemInstance
extends Resource

var data: ItemData
var quality: String = ""
var disc: String = ""
var components: Dictionary = {}

signal component_changed(slot_id: String)

# component_pool — словарь: ComponentType → Array[ComponentData]
static func create_random(from_data: ItemData, component_pool: Dictionary) -> ItemInstance:
	var inst = ItemInstance.new()
	inst.data = from_data
	inst.quality = from_data.q.pick_random()
	inst.disc = from_data.disc

	for slot in from_data.component_slots:
		var available: Array = component_pool.get(slot.accepted_types[0], [])
		if available.is_empty():
			inst.components[slot.slot_id] = null
			continue

		if not slot.required and randf() < 0.2:
			inst.components[slot.slot_id] = null
			continue

		var comp_data: ComponentData = available.pick_random()
		inst.components[slot.slot_id] = ComponentInstance.create_random(comp_data)

	return inst

func place_component(slot_id: String, component: ComponentInstance) -> bool:
	var slot = _get_slot(slot_id)
	if slot == null:
		return false
	if not slot.accepted_types.has(component.data.component_type):
		return false
	components[slot_id] = component
	component_changed.emit(slot_id)
	return true

func remove_component(slot_id: String) -> ComponentInstance:
	var comp = components.get(slot_id, null)
	components[slot_id] = null
	component_changed.emit(slot_id)
	return comp

func is_functional() -> bool:
	for slot in data.component_slots:
		if slot.required and components.get(slot.slot_id) == null:
			return false
	return true

func _get_slot(slot_id: String) -> ComponentSlotData:
	for slot in data.component_slots:
		if slot.slot_id == slot_id:
			return slot
	return null
