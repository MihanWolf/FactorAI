class_name GarbageUI
extends CanvasLayer

signal burn_pressed
signal take_pressed
signal send_to_cart_pressed

@onready var item_name_label = $Panel/VBoxContainer/Label
@onready var item_quality_label = $Panel/VBoxContainer/Label2
@onready var item_description_label = $Panel/VBoxContainer/Label3
@onready var burn_button = $Panel/HBoxContainer/Button
@onready var send_to_cart_button = $Panel/HBoxContainer/Button2
@onready var take_button = $Panel/HBoxContainer/Button3


func _ready():
	burn_button.pressed.connect(func(): 
		burn_pressed.emit()
	)
	take_button.pressed.connect(func(): 
		take_pressed.emit()
	)
	send_to_cart_button.pressed.connect(func():
		send_to_cart_pressed.emit()
	)
	hide()
	
func show_item(instance: ItemInstance):
	item_name_label.text = instance.data.item_name
	item_quality_label.text = instance.quality
	item_description_label.text = instance.data.description
