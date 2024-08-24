class_name Bumper extends StaticBody2D

@export var force := 100.0

@onready var repulser: Area2D = %repulser

func _ready() -> void:
	repulser.body_entered.connect(_body_entered)

func _body_entered(_body) -> void:
	if _body is PlayerCar:
		var direction = _body.global_position - global_position
		_body.push(direction * force)
