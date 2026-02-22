extends CanvasLayer

signal burn_pressed
signal recycle_pressed
signal take_pressed

@onready var item_name_label = $Panel/VBoxContainer/Label
@onready var item_quality_label = $Panel/VBoxContainer/Label2
@onready var item_disc_label = $Panel/VBoxContainer/Label3
@onready var burn_button = $Panel/HBoxContainer/Button
@onready var recycle_button = $Panel/HBoxContainer/Button2
@onready var take_button = $Panel/HBoxContainer/Button3

func _ready():
	burn_button.pressed.connect(func(): burn_pressed.emit())
	recycle_button.pressed.connect(func(): recycle_pressed.emit())
	take_button.pressed.connect(func(): take_pressed.emit())
	hide()

func show_item(instance: ItemInstance):
	item_name_label.text = instance.data.item_name
	item_quality_label.text = instance.quality
	item_disc_label.text = instance.disc
