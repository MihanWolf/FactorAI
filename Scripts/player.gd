class_name Player
extends CharacterBody2D

signal interact_pressed


@export var speed: float = 200.0
@onready var cart_hold_point = $CartHoldPoint

var zones_in_range: Array = []
var carried_cart: Cart = null


func _ready() -> void:
	add_to_group("player")

func _find_cart_in_range() -> Cart:
	for node in get_tree().get_nodes_in_group("cart"):
		if node.player_in_range:
			return node
	return null


func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	move_and_slide()
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):  # E например
		for zone in zones_in_range:
			zone.try_interact()
	
	if event.is_action_pressed("carry"):  # F
		if carried_cart:
			_drop_cart()
		else:
			var cart = _find_cart_in_range()
			if cart:
				_pickup_cart(cart)

func register_zone(zone: InteractionZone):
	if not zones_in_range.has(zone):
		zones_in_range.append(zone)

func unregister_zone(zone: InteractionZone):
	zones_in_range.erase(zone)

func _pickup_cart(cart: Cart):
	carried_cart = cart
	cart.get_node("inventory_ui").hide()  # прячем перед reparent
	cart.pickup()
	cart.reparent(self, false)
	var offset = cart.get_node("GrabPoint").position
	cart.position = cart_hold_point.position - offset

func _drop_cart():
	var drop_pos = carried_cart.global_position
	carried_cart.drop(drop_pos)
	carried_cart = null
