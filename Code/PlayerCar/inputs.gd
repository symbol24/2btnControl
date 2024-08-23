class_name Inputs extends Node2D

var parent:PlayerCar

func _ready() -> void:
	parent = get_parent() as PlayerCar

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("forward") and parent != null:
		parent.move_forward = true
	elif event.is_action_released("forward") and parent != null:
		parent.move_forward = false
	elif event.is_action_pressed("backward") and parent != null:
		parent.move_backward = true
	elif event.is_action_released("backward") and parent != null:
		parent.move_backward = false
	
