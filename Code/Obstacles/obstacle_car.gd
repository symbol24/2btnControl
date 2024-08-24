class_name ObstacleCar extends StaticBody2D

@export var car_colors:CarColorData

@onready var outline: Sprite2D = %outline
@onready var body: Sprite2D = %body
@onready var windows: Sprite2D = %windows

func _ready() -> void:
	_set_car_color()

func _set_car_color() -> void:
	var metallic := randi_range(0,1)
	if metallic == 1: body.frame = 1
	body.set_deferred("modulate", car_colors.colors.pick_random())
