# Scripts/UI/item_view.gd
class_name ItemView
extends Node2D

# Каждый компонент — отдельный Sprite2D слой
var _layer_sprites: Dictionary = {}  # slot_id → Sprite2D

func display(instance: ItemInstance) -> void:
	# Очищаем старые слои
	for child in get_children():
		child.queue_free()
	_layer_sprites.clear()
	
	# Базовый спрайт предмета
	var base = Sprite2D.new()
	base.texture = instance.data.base_sprite
	add_child(base)
	
	# Слой каждого компонента
	var slots_sorted = instance.data.component_slots.duplicate()
	slots_sorted.sort_custom(func(a, b): return a.sprite_layer_index < b.sprite_layer_index)
	
	for slot in slots_sorted:
		var comp = instance.components.get(slot.slot_id)
		if comp == null:
			continue
		
		var sprite = Sprite2D.new()
		# Берём первый слой спрайта компонента (можно усложнить)
		if comp.data.sprite_layers.size() > 0:
			sprite.texture = comp.data.sprite_layers[0]
		
		# Применяем цветовые перекраски через ShaderMaterial
		if comp.color_overrides.size() > 0:
			sprite.material = _create_color_material(comp.color_overrides)
		
		add_child(sprite)
		_layer_sprites[slot.slot_id] = sprite

func _create_color_material(overrides: Dictionary) -> ShaderMaterial:
	# Здесь шейдер для перекраски по маске
	# Это отдельная тема — palette swap shader
	var mat = ShaderMaterial.new()
	# ... настройка шейдера
	return mat
