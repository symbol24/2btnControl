class_name OilSlick extends Area2D

const SLIPS = preload("res://Data/Audio/slips.tres")

func _ready() -> void:
	body_entered.connect(_body_entered)

func _body_entered(_body) -> void:
	if _body is PlayerCar:
		S.PlayAudio.emit(SLIPS)
		_body.oil_spin()
