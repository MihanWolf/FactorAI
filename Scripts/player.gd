class_name Player
extends CharacterBody2D

@export var speed: float = 200.0

var zones_in_range: Array = []

signal interact_pressed

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	move_and_slide()
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
			for zone in zones_in_range:
				zone.try_interact()

func register_zone(zone: InteractionZone):
	if not zones_in_range.has(zone):
		zones_in_range.append(zone)

func unregister_zone(zone: InteractionZone):
	zones_in_range.erase(zone)
