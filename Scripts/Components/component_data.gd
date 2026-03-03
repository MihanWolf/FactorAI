
class_name ComponentData
extends Resource

@export var component_name: String = ""
@export var component_type: ComponentType
@export var compatible_items: Array[String] = []  # теги совместимости, например ["radio", "electronics"]
@export var sprite_layers: Array[Texture2D] = []  # слои спрайта (base, overlay, detail)
@export var color_regions: Array[String] = []  # какие регионы можно перекрашивать
@export var base_weight: float = 1.0  # влияет на вес предмета
@export var base_value: float = 10.0

enum ComponentType {
	CHASSIS,      # корпус
	CIRCUIT,      # плата
	WIRE,         # провода
	SPEAKER,      # динамик
	POWER,        # источник питания
	LENS,         # линза/стекло
	FASTENER,     # крепёж (болты, винты)
}
