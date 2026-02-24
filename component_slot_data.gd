
class_name ComponentSlotData
extends Resource

@export var slot_id: String = ""               # уникальный id, например "chassis"
@export var slot_label: String = ""            # отображаемое имя "Корпус"
@export var accepted_types: Array[ComponentData.ComponentType] = []
@export var required: bool = true              # без этого предмет не работает
@export var sprite_layer_index: int = 0        # в каком слое рендерится этот слот
@export var interaction_area: Rect2 = Rect2()  # область клика в UI разборки
