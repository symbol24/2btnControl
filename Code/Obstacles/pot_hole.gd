class_name PotHole extends Area2D

const POT_HOLE = preload("res://Data/Audio/pot_hole.tres")

@onready var hole_1: TileMapLayer = %hole1
@onready var hole_2: TileMapLayer = %hole2
@onready var hole_3: TileMapLayer = %hole3

func _ready() -> void:
	var chance = randf_range(0,1)
	if chance <= 0.33:
		hole_1.show()
	elif chance <= 0.66:
		hole_2.show()
	else:
		hole_3.show()
	body_entered.connect(_body_entered)
	body_exited.connect(_body_exited)

func _body_entered(_body) -> void:
	if _body is PlayerCar:
		S.PlayAudio.emit(POT_HOLE)
		_body.pot_hole()

func _body_exited(_body) -> void:
	if _body is PlayerCar:
		_body.end_pot_hole()
