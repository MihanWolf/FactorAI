class_name DisassemblySystem

enum RemoveResult {
	OK,                # Можно снять
	EMPTY,             # Слот уже пустой
	BLOCKED_BY_LAYER,  # Сверху лежит другой компонент — сначала сними его
	NEEDS_TOOL,        # Требуется инструмент которого нет
}


# Проверяет можно ли снять компонент из слота.
static func can_remove(
	item: ItemInstance,
	slot_id: String,
	tool_item: ItemInstance
) -> RemoveResult:

	# Слот пустой — нечего снимать
	if item.components.get(slot_id) == null:
		return RemoveResult.EMPTY

	# Слот заблокирован компонентом на слое выше
	if item.is_slot_blocked(slot_id):
		return RemoveResult.BLOCKED_BY_LAYER

	# Проверяем требование к инструменту
	var slot := item._get_slot(slot_id)
	if slot != null and slot.required_tool != "":
		if tool_item == null:
			return RemoveResult.NEEDS_TOOL
		if tool_item.data.item_name != slot.required_tool:
			return RemoveResult.NEEDS_TOOL

	return RemoveResult.OK


# Снимает компонент из слота и возвращает его как ItemInstance-обёртку.
static func remove_component(
	item: ItemInstance,
	slot_id: String
) -> ItemInstance:

	var comp: ComponentInstance = item.remove_component(slot_id)
	if comp == null:
		return null

	return ItemInstance.wrap_component(comp)


# Удобный метод — проверяет и снимает за один вызов.
static func try_remove(
	item: ItemInstance,
	slot_id: String,
	tool_item: ItemInstance
) -> Array:

	var check: RemoveResult = can_remove(item, slot_id, tool_item)
	if check != RemoveResult.OK:
		return [check, null]

	var wrapped: ItemInstance = remove_component(item, slot_id)
	return [RemoveResult.OK, wrapped]
