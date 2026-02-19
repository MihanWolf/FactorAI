extends Control

@onready var title_label = $VBoxContainer/Label
@onready var slots_container = $VBoxContainer/HBoxContainer
var slot_ui_scene: PackedScene = preload("res://Scenes/UI/slot_ui.tscn")

func init(storage: Storage):
	title_label.text = storage.storage_name
	for child in slots_container.get_children():
		child.queue_free()
	for i in storage.slots.size():
		var slot_ui = slot_ui_scene.instantiate()
		slots_container.add_child(slot_ui)
		slot_ui.update(storage.slots[i])
	storage.slot_changed.connect(func(index):
		slots_container.get_child(index).update(storage.slots[index])
	)
